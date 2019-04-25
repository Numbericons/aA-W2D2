require "colorize"
require_relative "board.rb"
require_relative "cursor.rb"

class Display
    attr_reader :cursor, :board
    def initialize(board)
        @board = board
        @cursor = Cursor.new([7,0],@board)
    end

    def take_turn
        until false == true
            system("clear")
            self.render
            @cursor.get_input
        end
    end

    def render
        board.grid.each_with_index do |row, row_i|
            row.each_with_index do |cell, cell_i|
                if [row_i, cell_i] != @cursor.cursor_pos 
                    print cell.to_s.on_light_red if (row_i + cell_i).odd?
                    print cell.to_s.on_red if (row_i + cell_i).even?
                elsif self.cursor.selected
                    print cell.to_s.green.on_magenta
                else
                    print cell.to_s.cyan.on_yellow
                end
            end
            puts
        end
    end 
end

# b = Board.new
# d = Display.new(b)
# d.take_turn