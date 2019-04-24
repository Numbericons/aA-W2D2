# require_relative 'slideable.rb'
# require_relative 'stepable.rb'
require "singleton"

class Piece
    attr_reader :color
    def initialize(color = nil)
        @symbol = "\u265F"
        @color
    end

    def inspect
        @symbol
    end

    def to_s
        " " + @symbol.to_s + " "
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
end