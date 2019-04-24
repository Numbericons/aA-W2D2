require_relative "piece.rb"
require 'byebug'
class PieceMoveError < StandardError
    def nilMessage
        "No piece at that starting location!"
    end

    def endMessage
        "You cannot move to or from that location!"
    end
end
class Board
    attr_reader :grid, :cursor
    def initialize
        @grid = Array.new(8) {Array.new(8)}
        populate_board
    end 

    def populate_board
        self.grid.each_with_index do |rows, row_i|
            if row_i.between?(2,5)
                rows.map!{|cell| NullPiece.instance}
            else
                rows.map!{|cell| Piece.new}
            end
        end
    end

    def move_piece(start_pos, end_pos)
        in_bounds = self.valid_pos?(start_pos) && self.valid_pos?(end_pos)
        begin
            if self[start_pos].nil? || !in_bounds
                raise PieceMoveError
            end
            
            self[end_pos], self[start_pos] = self[start_pos], self[end_pos]
         
        rescue  PieceMoveError => e
            if self[start_pos].nil?
                e.nilMessage
            elsif !in_bounds
                e.endMessage
            end
        end
    end

    def valid_pos?(pos)
        pos[0].between?(0,7) && pos[1].between?(0,7) 
    end

    def [](pos)
        x,y = pos
        self.grid[x][y]
    end

    def []=(pos,value)
        x,y = pos
        self.grid[x][y] = value
    end

end

# b = Board.new
# b.move_piece([0,0],[3,3])
# p b.grid