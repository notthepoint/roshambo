require 'sinatra'
require './lib/player.rb'

set :bind, '0.0.0.0'
set :player, Player.new

get '/next_move' do
	previous = params['previous'] || ''
	settings.player.next_move previous
end