class CompetitionRunner
	def initialize(competitors, no_of_rounds=10)
		@competitors = competitors
		@no_of_rounds = no_of_rounds

		@results = []
	end

	def competition
		bouts = @competitors.each_slice(2).to_a
		bouts.each do |players|
			bout(players[0], players[1])
		end
	end

	def bout(player_1, player_2)
		referee = Referee.new(player_1, player_2, no_of_rounds)
		scores = referee.bout

		@results.push({
			player_1: player_1,
			player_2: player_2,
			scores: scores,
			winner: scores.max_by{ |_, val| val }[0]
			})
	end

	attr_accessor :no_of_rounds

	private
end