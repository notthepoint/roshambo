class CompetitionRunner
	def initialize(competitors, no_of_rounds_in_a_bout=2)
		@competition = Competition.create
		@competitors = competitors
		@no_of_rounds_in_a_bout = no_of_rounds_in_a_bout
		@no_of_matches = Math.log2(@competitors.length).to_i
		@referee = Referee.new(@competition, no_of_rounds_in_a_bout)

		@match_results = []
	end

	def competition
		match_competitors = @competitors
		
		@no_of_matches.times do |i|
			p "match competitors #{match_competitors}"
			match_competitors = match(match_competitors)
		end

		puts match_competitors.inspect
	end

	def match(match_competitors)
		bouts = match_competitors.each_slice(2).to_a
		winners = []

		bouts.each do |players|
			res = bout(players[0], players[1])
			puts "bout winner: #{res}"
			winners.push(res)
		end

		winners
	end

	def bout(player_1, player_2)
		match_scores = @referee.bout(player_1, player_2)

		# TODO: save this
		# {
		# 	player_1: player_1,
		# 	player_2: player_2,
		# 	scores: scores,
		# 	winner: 
		# }
		# scores.max_by{ |_, val| val }[0]
		match_scores.winner
	end

	attr_accessor :no_of_rounds_in_a_bout

	private
end