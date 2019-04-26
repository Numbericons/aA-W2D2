require_relative 'board.rb'
require_relative 'cursor.rb'
require_relative 'display.rb'
require_relative 'piece.rb'
require_relative 'player.rb'
require 'byebug'

class Game
    attr_reader :board, :display, :current_player
    def initialize
        @board = Board.new
        @display = Display.new(board)
        @player1 = HumanPlayer.new(display, :white)
        @player2 = HumanPlayer.new(display, :black)
        @current_player = @player1
    end

    def play
        start_pos = []
        end_pos = []
        
        until game_over?
            # debugger
            begin
                until cursor_input
                    start_pos = self.display.cursor.cursor_pos.dup
                end
                until cursor_input
                    end_pos = self.display.cursor.cursor_pos
                end
                self.board.move_piece(start_pos,end_pos)   
            rescue => exception
                raise "ERRORz"
                retry
            end
            
        end
        winner
    end

    def winner
        if board.checkmate?(:white)
            puts "BLACK HAS WON THE GAME!"
        elsif board.checkmate?(:black)
            puts "WHITE HAS WON THE GAME!"
        else
            puts "STALEMATE"
        end
    end

    def cursor_input
        system("clear")
        self.display.render
        current_player.make_move
    end

    def game_over?
        board.checkmate?(:white) || board.checkmate?(:black)
    end
end

chess = Game.new
chess.play
