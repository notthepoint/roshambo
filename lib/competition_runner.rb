class CompetitionRunner
	def initialize(no_of_rounds_in_a_bout=2)
		@no_of_rounds_in_a_bout = no_of_rounds_in_a_bout
	end

	def competition(competitors)
		set_up_competition(competitors)

		match_competitors = @competitors
		
		@no_of_matches.times do |i|
			match_competitors = match(match_competitors)
		end

		puts match_competitors.inspect
	end

	attr_accessor :no_of_rounds_in_a_bout

	private

	def set_up_competition(competitors)
		@competitors = competitors
		@competition = Competition.create
		@referee = Referee.new(@competition, no_of_rounds_in_a_bout)
		@no_of_matches = Math.log2(@competitors.length).to_i
	end

	def match(match_competitors)
		bouts = match_competitors.each_slice(2).to_a
		winners = []

		bouts.each do |players|
			match_scores = @referee.bout(players[0], players[1])
			winners.push(match_scores.winner)
		end

		winners
	end
end