# require_relative 'slideable.rb'
# require_relative 'stepable.rb'
require "singleton"

class Piece
    def initialize
        @symbol = :Piece
    end

    def inspect
        @symbol
    end
end

class NullPiece < Piece
    include Singleton
    def initialize
        @symbol = :Null
    end

    def nil?
        true
    end
end