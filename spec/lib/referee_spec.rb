require "rails_helper"
require "./lib/referee.rb"

RSpec.describe Referee do
  describe '#bout' do
    let(:player_1) { create(:bot) }
    let(:player_2) { create(:bot) }

    let(:player_bot) { double(:player_bot, next_move: 'r', ready?: true, stop: true)}
    let(:player) { double(:player, new: player_bot) }

    it 'sets up players' do
      referee = described_class.new(player: player)

      referee.bout(no_of_rounds_in_a_bout: 2, player_1: player_1, player_2: player_2, match_no: 1)

      expect(referee.players).to eq({
        player_1: player_1,
        player_2: player_2
      })
    end

    it 'sets up player bots' do
      referee = described_class.new(player: player)

      referee.bout(no_of_rounds_in_a_bout: 2, player_1: player_1, player_2: player_2, match_no: 1)
       
      expect(player).to have_received(:new).exactly(2).times
    end

    it 'creates match scores' do
      referee = described_class.new(player: player)

      bout_scores = referee.bout(no_of_rounds_in_a_bout: 2, player_1: player_1, player_2: player_2, match_no: 1)

      expect(bout_scores[:bout_scores][:player_1]).to eq player_1.id
      expect(bout_scores[:bout_scores][:player_2]).to eq player_2.id
    end

    it 'runs the correct amount of rounds' do
      referee = described_class.new(player: player)

      referee.bout(no_of_rounds_in_a_bout: 3, player_1: player_1, player_2: player_2, match_no: 1)

      expect(referee.rounds.length).to eq 4
    end

    it 'builds rounds hash' do
      referee = described_class.new(player: player)

      referee.bout(no_of_rounds_in_a_bout: 3, player_1: player_1, player_2: player_2, match_no: 1)

      expect(referee.rounds).to eq([
        {
          player_1: '',
          player_2: ''
        },
        {
          player_1: 'r',
          player_2: 'r'
        },
        {
          player_1: 'r',
          player_2: 'r'
        },
        {
          player_1: 'r',
          player_2: 'r'
        }
      ])
    end

    it 'stops player bots' do
      referee = described_class.new(player: player)

      referee.bout(no_of_rounds_in_a_bout: 2, player_1: player_1, player_2: player_2, match_no: 1)
       
      expect(player_bot).to have_received(:stop).exactly(2).times
    end

    it 'returns a bout scores hash' do
      referee = described_class.new(player: player)

      result = referee.bout(no_of_rounds_in_a_bout: 3, player_1: player_1, player_2: player_2, match_no: 10)

      expect(result[:bout_scores]).to eq({
        player_1: player_1.id,
        player_2: player_2.id,
        player_1_score: 0,
        player_2_score: 0,
        draws: 3,
        match_no: 10
        })
    end
  end
end