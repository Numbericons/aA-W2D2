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
        starting_order = [:R,:K,:B,:Q,:X,:B,:K,:R]

        self.grid.each_with_index do |row, row_i|
            if row_i.between?(2,5)
                row.map!{|cell| NullPiece.instance}
            elsif row_i == 1
                row.each_with_index do |cell, cell_i| 
                    add_piece([row_i, cell_i],:white, :P)
                end
            elsif row_i == 0
                row.each_with_index do |cell, cell_i| 
                    add_piece([row_i, cell_i],:white, starting_order[cell_i])
                end
            elsif row_i == 6
                row.each_with_index do |cell, cell_i| 
                    add_piece([row_i, cell_i],:black, :P)
                end
                # row.map!{|cell| Piece.new(:black)}
            elsif row_i == 7
                row.each_with_index do |cell, cell_i| 
                    add_piece([row_i, cell_i],:black, starting_order[cell_i])
                end
            end
        end
    end
    
    def add_piece(pos, symbol, piece_sym)
        case piece_sym
        when :P
            self[pos] = Pawn.new(pos, symbol, self)
        when :R
            self[pos] = Rook.new(pos, symbol, self)
        when :K
            self[pos] = Knight.new(pos, symbol, self)
        when :B
            self[pos] = Bishop.new(pos, symbol, self)
        when :X
            self[pos] = King.new(pos, symbol, self)
        when :Q
            self[pos] = Queen.new(pos, symbol, self)
        end
    end

    def move_piece(start_pos, end_pos)
        in_bounds = self.valid_pos?(start_pos) && self.valid_pos?(end_pos)
        begin
            if self[start_pos].nil? || !in_bounds
                raise PieceMoveError
            end
            
            self[end_pos], self[start_pos] = self[start_pos], self[end_pos]
            self[end_pos].position = end_pos
            self[start_pos].position = start_pos
         
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