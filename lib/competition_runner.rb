class CompetitionRunner
	def initialize
	end

	def run_competition(competition: Competition.create, referee: Referee, competitors:, no_of_rounds_in_a_bout: 2)
		set_up_competition(competition, referee, competitors)
		compete
	end

	private

	attr_accessor :no_of_rounds_in_a_bout, :competition, :referee, :competitors

	def set_up_competition(competition, referee, competitors)
		@competition = competition
		@referee = referee
		@competitors = competitors
		@no_of_matches = Math.log2(@competitors.length).to_i
	end

	def compete
		match_competitors = @competitors
		
		@no_of_matches.times do |i|
			match_competitors = match(match_competitors)
		end

		puts match_competitors.inspect
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