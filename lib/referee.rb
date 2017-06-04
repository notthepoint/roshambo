class Referee
	BEATS = {
		'r' => 's',
		's' => 'p',
		'p' => 'r',
	}.freeze

	def initialize(player: Player)
		@player = player
		@bout_scores = nil
	end

	def bout(no_of_rounds_in_a_bout:, player_1:, player_2:, match_no: 0)
		set_empty_variables
		set_up_bout(
			no_of_rounds_in_a_bout: no_of_rounds_in_a_bout,
			player_1: player_1,
			player_2: player_2,
			match_no: match_no
		)
	  wait_for_ready_player_bots

		run_rounds
		
		finish_bout

		{
			bout_scores: bout_scores,
			winner: winner
		}
	end

	attr_accessor :players, :rounds, :bout_scores

	private

	def set_up_bout(no_of_rounds_in_a_bout:, player_1:, player_2:, match_no:)
		@no_of_rounds_in_a_bout = no_of_rounds_in_a_bout

		@players = {
			player_1: player_1,
			player_2: player_2
		}

		@player_bots = {
			player_1: @player.new(player_1.code),
		  player_2: @player.new(player_2.code)
		}

		@bout_scores = {
		  player_1: player_1.id,
		  player_2: player_2.id,
		  player_1_score: 0,
		  player_2_score: 0,
		  draws: 0,
		  match_no: match_no
		}
	end

	def run_rounds
		@no_of_rounds_in_a_bout.times do
			round_results = round

			rounds.push(round_results)
			update_scores(round_results)
		end
	end

	def round
		{}.tap do |round|
	    round[:player_1] = validate(@player_bots[:player_1].next_move(rounds.last[:player_2]))
			round[:player_2] = validate(@player_bots[:player_2].next_move(rounds.last[:player_1]))
		end
	end

	def update_scores(round_results)
		if round_results[:player_1] == round_results[:player_2]
			bout_scores[:draws] += 1
		elsif BEATS[round_results[:player_1]] == round_results[:player_2]
			bout_scores[:player_1_score] += 1
		else
			bout_scores[:player_2_score] += 1
		end
	end

	def validate(result)
		result.tap do |result|
			raise StandardError, "#{result} invalid" unless BEATS.keys.include? result
		end
	end

	def stop_player_bots
		@player_bots.map do |_,player|
			player.stop
		end
	end

	def set_empty_variables
		@players = { player_1: nil, player_2: nil }
		@player_bots = { player_1: nil, player_2: nil }
		@rounds = [{ player_1: '', player_2: '' }]
	end

	def wait_for_ready_player_bots
	  @player_bots.all? { |_,player| player.ready? }
	end

	def finish_bout
		stop_player_bots
	end

	def winner
		if @bout_scores[:player_1_score] > @bout_scores[:player_2_score]
			@players[:player_1]
		elsif @bout_scores[:player_2_score] > @bout_scores[:player_1_score]
			@players[:player_2]
		else
			nil
		end
	end
end