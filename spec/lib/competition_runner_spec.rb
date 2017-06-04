require "rails_helper"
require "./lib/competition_runner.rb"

RSpec.describe CompetitionRunner do
  describe '#run_competition' do
    let(:referee_result) { 
      {scores: { something: 'yeah' },
            winner: bot_players.sample}
    }
    let(:bot_players) { build_list(:bot, 2) }
    let(:referee) { double(:referee, bout: referee_result) }

    it 'returns scores from referee' do
      comp_runner = described_class.new

      results = comp_runner.run_competition(
        referee: referee,
        competitors: bot_players)
      
      expect(results[0]).to have_key(:something)
    end

  	context 'with an odd number of players' do
  		let(:bot_players) { build_list(:bot, 5) }

  		it 'creates bayes players' do
  		end

  		it 'runs the correct number of matches' do
  		end
  	end

  	context 'with an even number of players' do
  		let(:referee) { double(:referee,
  			bout: bot_players.sample) }
  		let(:bot_players) { build_list(:bot, 8) }

  		it 'runs the correct number of matches' do
  			comp_runner = described_class.new

  			expect(comp_runner).to receive(:run_match).exactly(3).times

  			comp_runner.run_competition(
  				referee: referee,
  				competitors: bot_players)
  		end
  	end

  	context 'with draws' do
  	end
  end
end