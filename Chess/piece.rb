# require_relative 'slideable.rb'
# require_relative 'stepable.rb'
require "singleton"

class Piece
    def initialize
        @name = "Piece"
    end

    def inspect
        @name
    end
end

class NullPiece < Piece
    include Singleton
    def initialize
        @name = "NullPiece"
    end

    def nil?
        true
    end
end