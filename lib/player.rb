class Player
	attr_reader :container, :code

	def initialize(code)
		Excon.defaults[:ssl_verify_peer] = false
		@code = code
		@container = run
	end

	def next_move(previous='')
    response = JSON.parse(HTTParty.get(url, query: { previous: previous }).body)["move"]

    response
	end

	def stop
		container.stop
	end

	private

	def run
		image.run('ruby app.rb', options = {
			'Env' => ['RACK_ENV=docker'], # make sure the 0.0.0.0 bind works, if development listens on localhost
			'ExposedPorts' => { '4567/tcp' => {} }, # default sinatra port
			'Volumes' => { '/app/lib/player.rb' => {} }, # mount volume, where container app is expecting it
		  'HostConfig' => {
	    	'Binds' => ["/private#{path}:/app/lib/player.rb"], # comes from:goes to
	    	'PublishAllPorts' => true, # required to get it to work
	    }
	  })
	end


	def url
		# 0.0.0.0 is set in sinatra app also
		"http://0.0.0.0:#{port}/next_move"
	end

	def port
		# port on our machine, what is forwarded to player docker container
		@port ||= network_settings['Ports']['4567/tcp'][0]['HostPort']
	end

	def network_settings
		# need to fetch further network settings
		@network_settings ||= Docker::Container.get(container.id).info['NetworkSettings']
	end

	def path
		@path ||= begin
			fi = Tempfile.new('roshambo')
			fi.write(code)
			fi.close
			fi.path
		end
	end

	def image
		Docker::Image.build_from_dir('player')
	end
end