class Referee
	BEATS = {
		'r' => 's',
		's' => 'p',
		'p' => 'r',
	}.freeze

	def initialize(competition:, no_of_rounds:, player: Player)
		@player = player
		@competition = competition
		@no_of_rounds = no_of_rounds

		@match_scores = nil
	end

	def bout(player_1, player_2)
		set_initial_variables
		set_up_bout(player_1, player_2)
	  wait_for_ready_player_bots

		run_rounds
		
		finish_bout
		match_scores
	end

	attr_accessor :players, :rounds, :match_scores

	private

	def set_up_bout(player_1, player_2)

		@players = {
			player_1: player_1,
			player_2: player_2
		}

		@player_bots = {
			player_1: @player.new(player_1.code),
		  player_2: @player.new(player_2.code)
		}

		@match_scores = MatchScore.new({
		  competition: @competition,
		  player_1: player_1,
		  player_2: player_2})
	end

	def run_rounds
		@no_of_rounds.times do
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
			match_scores.draws += 1
		end

		if BEATS[round_results[:player_1]] == round_results[:player_2]
			match_scores.player_1_score += 1
		else
			match_scores.player_2_score += 1
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

	def set_initial_variables
		@players = { player_1: nil, player_2: nil }
		@player_bots = { player_1: nil, player_2: nil }
		@rounds = [{
			player_1: '',
			player_2: ''
		}]
	end

	def wait_for_ready_player_bots
	  @player_bots.all? { |_,player| player.ready? }
	end

	def finish_bout
		stop_player_bots

		match_scores.save
	end
end