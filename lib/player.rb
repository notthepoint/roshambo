class Player
	attr_reader :container, :code

	def initialize(code)
		@code = code
		@container = run
	end

	def next_move(previous='')
    connection.request({
    	method: :get,
  		path: '/next_move',
  		query: { previous: previous }
  	}).body
	end

	private

	def run
		image.run('ruby app.rb', options = {
			'Env' => ['RACK_ENV=docker'],
			'ExposedPorts' => { '4567/tcp' => {} },
			'Volumes' => { '/app/lib/player.rb' => {} },
		  'HostConfig' => {
	    	'Binds' => ["/private#{path}:/app/lib/player.rb"],
	    	'PublishAllPorts' => true,
	    }
	  })
	end

	def connection
		Excon.new(url, {})
	end

	def url
		"http://0.0.0.0:#{port}"
	end

	def port
		@port ||= network_settings['Ports']['4567/tcp'][0]['HostPort']
	end

	def network_settings
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