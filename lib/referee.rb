class Referee
	def initialize(player1, player2, no_of_rounds)
		@player_1 = Player.new(player1.code)
		@player_2 = Player.new(player2.code)
		@no_of_rounds = no_of_rounds
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

	def bout
		@no_of_rounds.times do
			round_results = round

			rounds.push(round_results)
			update_scores(round_results)
		end
		
		scores
	end

	attr_accessor :player_1, :player_2, :rounds, :scores

	private

	def round
		{}.tap do |round|
	    round[:player_1] = player_1.next_move(rounds.last[:player_2])
			round[:player_2] = player_2.next_move(rounds.last[:player_1])
		end
	end

	def update_scores(round_results)
		p round_results
		scores[round_winner(round_results)] += 1
	end

	def round_winner(round_results)
		p round_results
		calculate_winner(round_results[:player_1], round_results[:player_2])
	end

	def calculate_winner(round_results_1, round_results_2)
		p "res 1 #{round_results_1}"
		p "res 2 #{round_results_2}"
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
end