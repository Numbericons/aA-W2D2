require_relative 'board.rb'
require_relative 'cursor.rb'
require_relative 'display.rb'
require_relative 'piece.rb'
require_relative 'player.rb'
require 'byebug'

b = Board.new
d = Display.new(b)
# d.take_turn