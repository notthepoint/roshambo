require "rails_helper"
require "./lib/competition_runner.rb"

RSpec.describe CompetitionRunner do
  describe '#run_competition' do
  	let(:referee) { double(:referee) }

  	context 'with an odd number of players' do
  		let(:bot_players) { build_list(:bot, 5) }

  		it 'creates bayes players' do
  		end

  		it 'runs the correct number of matches' do
  		end
  	end

  	context 'with an even number of players' do
  		let(:competition) { double(:competition) }
  		let(:referee) { double(:referee,
  			bout: bot_players.sample) }
  		let(:bot_players) { build_list(:bot, 8) }

  		it 'runs the correct number of matches' do
  			comp_runner = described_class.new

  			expect(comp_runner).to receive(:match).exactly(3).times

  			comp_runner.run_competition(
  				competition: competition,
  				referee: referee,
  				competitors: bot_players)
  		end
  	end

  	context 'with draws' do
  	end
  end
end