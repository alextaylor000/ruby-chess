require "./chess_helpers.rb"

class Piece
  include ChessHelpers
  attr_accessor :position
  attr_reader :owner # which player owns this piece?
  attr_reader :type  # not set here, but it will be set by each piece
  attr_reader :rotation
  attr_reader :possible_offsets
  attr_reader :jumps_to_target

  def initialize(game, owner)
    @game     = game
    @owner    = owner

    @position = [-1,-1]
    @possible_offsets = []
    @jumps_to_target = false # kings and pawns can only move one tile at a time
    @special_moves = {}

    # @possible_offsets below is written using the "bottom" pieces as reference.
    #   so, when moving top pieces, we need to rotate the coordinates by 180
    #   degrees by multiplying both axes by -1.
    @rotation = owner.home_base == :top ? -1 : 1

  end

  def add_to_board_at(pos_arr)
    @game.board.add_piece self, pos_arr
    pos_x, pos_y = pos_arr
    @position = [pos_x, pos_y]
  end

  def special_moves(k=nil)
    # for pieces like pawns and kings, stores an
    #   array of possible moves that can be used
    #   under certain circumstances.
    if k
      @special_moves[k]
    else
      @special_moves
    end
  end

end # class
