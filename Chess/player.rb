class HumanPlayer
    attr_reader :display
    def initialize(display, color)
        @display = display
        @color = color
    end

    def make_move
        display.cursor.get_input
    end
end

