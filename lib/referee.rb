class Referee
	BEATS = {
		'r' => 's',
		's' => 'p',
		'p' => 'r',
	}.freeze

	def initialize(competition, no_of_rounds)
		@competition = competition
		@no_of_rounds = no_of_rounds
		@players = {
			player_1: nil,
			player_2: nil
		}
		@player_bots = {
			player_1: nil,
			player_2: nil
		}
		@rounds = [{
			player_1: '',
			player_2: ''
		}]

		@match_scores = nil
	end

	def bout(player_1, player_2)
		set_up_bout(player_1, player_2)

	  wait_for_ready_player_bots

		@no_of_rounds.times do
			round_results = round

			rounds.push(round_results)
			update_scores(round_results)
		end
		
		stop_player_bots
		reset_players

		match_scores.save
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
			player_1: Player.new(player_1.code),
		  player_2: Player.new(player_2.code)
		}

		@match_scores = MatchScore.new
		@match_scores.competition = @competition
		@match_scores.player_1 = player_1
		@match_scores.player_2 = player_2
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

	def reset_players
		players.map { |player_name, player| [player_name, nil] }.to_h
		@player_bots.map { |player_name, player| [player_name, nil] }.to_h
	end

	# def formatted_scores
	# 	# @scores.map { |player, score| [players[player], score] }.to_h
	# 	Match.new({
	# 		player_1: players[:player_1],
	# 		player_2: players[:player_2],
	# 		player_1_score:
	# 		})
	# end

	def wait_for_ready_player_bots
	  @player_bots.all? { |_,player| player.ready? }
	end
end