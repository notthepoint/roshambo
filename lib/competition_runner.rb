class CompetitionRunner
	def initialize
	end

	def run_competition(referee: Referee.new, competitors:, no_of_rounds_in_a_bout: 2)
		set_up_competition(referee, competitors, no_of_rounds_in_a_bout)
		compete
	end

	private

	attr_accessor :no_of_rounds_in_a_bout, :referee, :competitors, :bout_scores

	def set_up_competition(referee, competitors, no_of_rounds_in_a_bout)
		@no_of_rounds_in_a_bout = no_of_rounds_in_a_bout
		@referee = referee
		@competitors = competitors
		@no_of_matches = Math.log2(@competitors.length).to_i
		@bout_scores = []
	end

	def compete
		match_competitors = @competitors
		
		@no_of_matches.times do |i|
			match_competitors = run_match(i, match_competitors)
		end

		bout_scores
	end

	def run_match(match_no, match_competitors)
		bouts = match_competitors.each_slice(2).to_a
		winners = []

		bouts.each do |players|
			bout_results = @referee.bout(
				no_of_rounds_in_a_bout: no_of_rounds_in_a_bout,
				player_1: players[0],
				player_2: players[1],
				match_no: match_no)

			bout_scores.push(bout_results[:scores])
			winners.push(bout_results[:winner])
		end

		winners
	end
end
