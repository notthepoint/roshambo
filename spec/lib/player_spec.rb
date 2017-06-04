require "rails_helper"
require "./lib/player.rb"

RSpec.describe Player do
  let(:user) { create(:user) }
  let(:bot) do
    create(
      :bot,
      code: "class Player; def next_move(prev); 'random!!'; end; end;",
      user: user)
  end

  after(:each) do
    Docker::Container.all(:all => true).each do |container|
      container.remove(force: true)
    end
  end

  describe '#next_move' do
    it 'returns the players move' do
      player = described_class.new(bot.code)

      player.ready?

      response = player.next_move

      expect(response).to eq 'random!!'
    end
  end

  describe '#ready?' do
    context 'server is not ready' do
      let(:response_code) { double(:response_code, code: 'nahmate') }
      let(:response) { double(:response, response: response_code) }

      before do
        allow(HTTParty).to receive(:get).and_return(response)
      end

      it 'does not try the ping url more than 5 times' do
        player = described_class.new(bot.code)

        expect(HTTParty).to receive(:get).exactly(5).times

        result = player.ready?
        expect(result).to eq false
      end
    end

    context 'when the server is ready' do
      let(:response_code) { double(:response_code, code: '200') }
      let(:response) { double(:response, response: response_code) }

      before do
        allow(HTTParty).to receive(:get).and_return(response)
      end

      it 'returns true when the server is ready' do
        player = described_class.new(bot.code)

        expect(HTTParty).to receive(:get).exactly(1).times

        result = player.ready?
        expect(result).to eq true
      end
    end
  end

  describe '#stop' do
    it 'calls stop on the container' do
      player = described_class.new(bot.code)

      pre_container_count = Docker::Container.all(all: true).count
      player.stop
      post_container_count = Docker::Container.all(all: true).count

      expect(post_container_count).to eq (pre_container_count - 1)
    end
  end
end