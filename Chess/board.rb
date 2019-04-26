require_relative "piece.rb"
require 'byebug'
class PieceMoveError < StandardError
    def nilMessage
        "No piece at that starting location!"
    end

    def endMessage
        "You cannot move to or from that location!"
    end

    def invalidMessage
        "This piece cannot move to that location!"
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
            if self[start_pos].nil? || !in_bounds || !self[start_pos].valid_moves.include?(end_pos)
                raise PieceMoveError
            end
            
            #NullPiece.instance
            if self[start_pos].color != self[end_pos].color
                self[end_pos] = self[start_pos]
                self[start_pos] = NullPiece.instance
            else
                self[end_pos], self[start_pos] = self[start_pos], self[end_pos] #collison
                self[start_pos].position = start_pos
            end
            self[end_pos].position = end_pos
         
        rescue  PieceMoveError => e
            if self[start_pos].nil?
                e.nilMessage
            elsif !in_bounds
                e.endMessage
            elsif !self[start_pos].valid_moves.include?(end_pos)
                e.invalidMessage
            end
        end
    end

    def move_piece!(start_pos, end_pos)
        in_bounds = self.valid_pos?(start_pos) && self.valid_pos?(end_pos)
        begin
            if self[start_pos].nil? || !in_bounds
                raise PieceMoveError
            end
            
            #NullPiece.instance
            if self[start_pos].color != self[end_pos].color
                self[end_pos] = self[start_pos]
                self[start_pos] = NullPiece.instance
            else
                self[end_pos], self[start_pos] = self[start_pos], self[end_pos] #collison
                self[start_pos].position = start_pos
            end
            self[end_pos].position = end_pos
         
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

    def in_check?(color)
        our_pieces = all_pieces
        king_pos = []
        our_pieces.each do |piece|   #array of all pieces
            king_pos = piece.position if piece.symbol == "\u265A" && piece.color == color
        end
        our_pieces.any? { |piece| piece.color != color && piece.moves.include?(king_pos) }
    end

    def all_pieces
        pieces_arr = self.grid.flatten
        pieces_arr.select { |piece| piece.symbol != " " }
    end

    def checkmate?(color)
        if in_check?(color) 
            player_pieces = all_pieces.select{|piece| piece.color == color}
            return true if player_pieces.all? { |piece| piece.valid_moves.empty? }
        end
        false
    end
    
    def dup
        duped_board = Board.new # new board w/ pieces at starting positions
        self.grid.each_with_index do |row, i|
            row.each_with_index do |col, j|
                if col.symbol != " "
                    duped_board[[i,j]] = col.class.new(col.position, col.color, col.symbol, duped_board)
                else
                    duped_board[[i,j]] = NullPiece.instance
                end
            end
        end
        duped_board
    end
end
