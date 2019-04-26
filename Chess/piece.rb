# require_relative 'slideable.rb'
# require_relative 'stepable.rb'
require "byebug"
require "singleton"
$LOAD_PATH << '.'
require 'modules.rb'

class Piece
    attr_reader :color, :board, :symbol
    attr_accessor :position
    def initialize(position = nil, color = nil, symbol = nil, board)
        @position = position
        @symbol ||= "\u265F"
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

    def valid_moves
        all_moves = self.moves
        next_turn_board = board.dup
        moves_arr = []

        all_moves.each do |move|
            next_turn_board.move_piece!(self.position,move)
            moves_arr << move unless next_turn_board.in_check?(self.color)
            next_turn_board.move_piece!(move,self.position) 
        end

        moves_arr
    end
end

class NullPiece < Piece
    include Singleton
    attr_reader :symbol, :color
    def initialize
        @symbol = " "
        @color = nil
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
    attr_reader :symbol, :color
    
    DIFFS = [
    [0,1],
    [0,-1],
    [1,0],
    [-1,0]
  ]

    def initialize(position = nil, color = nil, symbol = nil, board)
        super
        @symbol = "\u265C"	  #U+265C
    end
    def move_dirs
        DIFFS
    end
end

class Knight < Piece
    include Steppable
    attr_reader :symbol, :color
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

    def initialize(position = nil, color = nil, symbol = nil, board)
        super
        @symbol = "\u265E"	
    end
    def move_dirs
        DIFFS
    end
end


class Bishop < Piece
    attr_reader :symbol, :color
    include Slideable
    DIFFS = [
    [-1, -1],
    [-1, 1],
    [1, 1],
    [1, -1],
  ]

    def initialize(position = nil, color = nil, symbol = nil, board)
        super
        @symbol = "\u265D"	 #U+265D
    end
    def move_dirs
        DIFFS
    end
end

class Queen < Piece
    attr_reader :symbol, :color
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

    def initialize(position = nil, color = nil, symbol = nil, board)
        super
        @symbol = "\u265B"	 #U+265B
    end
    def move_dirs
        DIFFS
    end
end

class King < Piece
    attr_reader :symbol, :color
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

    def initialize(position = nil, color = nil, symbol = nil, board)
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
    attr_reader :symbol, :color
    
    attr_reader :initial_pos
    def initialize(position = nil, color = nil, symbol = nil, board)
        super
        @symbol = "\u265F"
        @initial_pos = position
    end
    
    def moves
        poss_moves = []
        if self.color == :white  
            diffs = [[1,0], [1,1], [1,-1]]
            diffs << [2,0] if self.position == self.initial_pos
        else
            diffs = [[-1,0], [-1,-1], [-1,1]]
            diffs << [-2,0] if self.position == self.initial_pos #conditional
        end
        
        diffs.each do |diff|  #diffs = [[1,0], [1,1], [-1,1], [2,0]]
            target = [self.position[0] + diff[0], self.position[1] + diff[1]]
            if self.board.valid_pos?(target)
                if self.board[target].nil? 
                    poss_moves << target if diff[1] == 0
                elsif self.board[target].color != self.color
                    poss_moves << target unless diff[1] == 0
                end
            end
           
        end

        poss_moves
    end
end