# require_relative 'slideable.rb'
# require_relative 'stepable.rb'
require "singleton"
$LOAD_PATH << '.'
require 'modules.rb'

class Piece
    attr_reader :color, :board
    attr_accessor :position
    def initialize(position = nil, color = nil, board)
        @position = position
        @symbol = "\u265F"
        @color = color
        @board = board
    end

    def inspect
        @symbol
    end

    def to_s
        if @color == :white 
            " " + @symbol.to_s.white + " "
        else
            " " + @symbol.to_s.black + " "
        end
    end
end

class NullPiece < Piece
    include Singleton
    def initialize
        @symbol = " "
    end

    def nil?
        true
    end

    def to_s
        "   "
    end
end

class Rook < Piece
    include Slideable
    
    DIFFS = [
    [0,1],
    [0,-1],
    [1,0],
    [-1,0]
  ]

    def initialize(position = nil, color = nil, board)
        super
        @symbol = "\u265C"	  #U+265C
    end
    def move_dirs
        DIFFS
    end
end

class Knight < Piece
    include Steppable
    
    DIFFS = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]

    def initialize(position = nil, color = nil, board)
        super
        @symbol = "\u265E"	
    end
    def move_dirs
        DIFFS
    end
end
class Bishop < Piece
    include Slideable
    DIFFS = [
    [-1, -1],
    [-1, 1],
    [1, 1],
    [1, -1],
  ]

    def initialize(position = nil, color = nil, board)
        super
        @symbol = "\u265D"	 #U+265D
    end
    def move_dirs
        DIFFS
    end
end

class Queen < Piece
    include Slideable
    DIFFS = [
    [-1, -1],
    [-1, 1],
    [1, 1],
    [1, -1],
    [0,1],
    [0,-1],
    [1,0],
    [-1,0]
  ]

    def initialize(position = nil, color = nil, board)
        super
        @symbol = "\u265B"	 #U+265B
    end
    def move_dirs
        DIFFS
    end
end

class King < Piece
    include Steppable
#     DIFFS = [
#     [-1, -1],
#     [-1, 1],
#     [1, 1],
#     [1, -1],
#     [0,1],
#     [0,-1],
#     [1,0],
#     [-1,0]
#   ]

    def initialize(position = nil, color = nil, board)
        super
        @symbol = "\u265A"
    end
    def move_dirs
        [[-1, -1],
        [-1, 1],
        [1, 1],
        [1, -1],
        [0,1],
        [0,-1],
        [1,0],
        [-1,0]]
    end
end

class Pawn < Piece
    DIFFS = [
   [0,1],
   [0,-1]
  ]

    def initialize(position = nil, color = nil, board)
        super
        @symbol = "\u265F"
    end
    def move_dirs
        DIFFS
    end
end