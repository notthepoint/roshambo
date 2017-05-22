def player(code)
				eval code 
				return Player.new
end

code = ARGV.clone
ARGV.clear

player = player(code.join('\n'))

ARGF.each_line do |line|
				mine, theirs = line.split ':'
				puts player.next_move(mine, theirs)
end

## e.g. 
## $ class Player; def next_move(mine, theirs); print mine; print theirs; end end
## $ r:p
