class Referee
	def initialize(no_of_rounds)
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
		@scores = {
			player_1: 0,
			player_2: 0,
			draws: 0,
			dud: 0
		}
	end

	def bout(player_1, player_2)
		@player_bots = {
			player_1: Player.new(player_1.code),
		  player_2: Player.new(player_2.code)
		}

	  wait_for_ready_player_bots

		@no_of_rounds.times do
			round_results = round

			rounds.push(round_results)
			update_scores(round_results)
		end
		
		stop_player_bots
		results = formatted_scores
		reset_players

		results
	end

	attr_accessor :players, :rounds, :scores

	private

	def round
		{}.tap do |round|
	    round[:player_1] = @player_bots[:player_1].next_move(rounds.last[:player_2])
			round[:player_2] = @player_bots[:player_2].next_move(rounds.last[:player_1])
		end
	end

	def update_scores(round_results)
		scores[round_winner(round_results)] += 1
	end

	def round_winner(round_results)
		calculate_winner(round_results[:player_1], round_results[:player_2])
	end

	def calculate_winner(round_results_1, round_results_2)
		case [round_results_1, round_results_2]
		when ['s','p'] || ['p','r'] || ['r','s']
			:player_1
		when ['r','p'] || ['s','r'] || ['p','s']
			:player_2
		when ['p','p'] || ['r','r'] || ['s','s']
			:draws
		else
			:dud
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

	def formatted_scores
		puts @scores
		@scores.map { |player, score| [players[player], score] }.to_h
	end

	def wait_for_ready_player_bots
	  @player_bots.all? { |_,player| player.ready? }
	end
end