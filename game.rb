require "byebug" # for debugging purposes

require "./board.rb"
require "./display.rb"
require "./player.rb"
require "./pawn.rb"
require "./rook.rb"
require "./knight.rb"
require "./bishop.rb"
require "./king.rb"
require "./queen.rb"

class Game
  # game objects
  attr_reader :board
  attr_reader :display
  attr_reader :state # this will hold the game's "state". is it player 1's turn?
                     #   has the player selected a piece? etc

  # using this plus the @cur_player variable, we determine what state the
  #   game is in and how it should respond to commands.
  GAME_STATES = [:select_piece,
                :move_piece]

  # this is used to convert chess coordinates (e.g. a4) to standard x,y coords
  NUMBER_FOR_LETTER = { "a" => 1,
                        "b" => 2,
                        "c" => 3,
                        "d" => 4,
                        "e" => 5,
                        "f" => 6,
                        "g" => 7,
                        "h" => 8 }

  def initialize
    @board      = Board.new
    @display    = Display.new board: @board
    @player1    = Player.new "Player 1", :bottom
    @player2    = Player.new "Player 2", :top
    @state      = GAME_STATES[0] # select_piece
    @cur_player = @player1
    add_pieces
    main_loop
  end

  private
  def main_loop
    # this will control the graphics, player input, etc.
    while true
      @display.update
      prompt_for @state
      input = gets.chomp
      process_command input
    end # while true
  end

  def prompt_for(state)
    # this determines what to display in each circumstance.
    case state
    when :select_piece
      string = "(#{@cur_player.name} #{@cur_player.home_base}) Select a piece (e.g. d2)"
    when :move_piece
      string = "(#{@cur_player.name} #{@cur_player.home_base}) Select a highlighted tile"
    end
    print string + " > "

  end

  def process_command(cmd)
    # takes the user's string and decides what to do with it.
    case cmd
    when "exit", "x"
      exit
    when cmd[/^[a^-zA-Z][0-9]$/]
      # matches two-character commands beginning with a letter
      #   and ending with a number.
      byebug
      case @state
      when :select_piece
        piece = board.piece_at(pos_for_coord(cmd))
        if piece.owner == @cur_player
          @state = :move_piece
          # TODO: display possible moves
          raise board.possible_moves_for(piece).inspect
        end


      end

    end

  end

  def pos_for_coord(coord_string)
    # converts a board coordinate (e.g. a4) into a proper coordinate
    x = NUMBER_FOR_LETTER[coord_string[0]]
    y = coord_string[1].to_i
    [x, y]
  end

  def add_pieces
    # builds each piece for each player and puts it on the board.
    # TODO: use metaprogramming to automatically instantiate the objects
    # TODO: god there's definitely a sexier way to do this...

    # add player 1 (bottom) pieces
    player = @player1
    (Rook.new(self, player)).add_to_board_at    [1,1]
    (Knight.new(self, player)).add_to_board_at  [2,1]
    (Bishop.new(self, player)).add_to_board_at  [3,1]
    (King.new(self, player)).add_to_board_at    [4,1]
    (Queen.new(self, player)).add_to_board_at   [5,1]
    (Bishop.new(self, player)).add_to_board_at  [6,1]
    (Knight.new(self, player)).add_to_board_at  [7,1]
    (Rook.new(self, player)).add_to_board_at    [8,1]

    (Pawn.new(self, player)).add_to_board_at    [1,2]
    (Pawn.new(self, player)).add_to_board_at    [2,2]
    (Pawn.new(self, player)).add_to_board_at    [3,2]
    (Pawn.new(self, player)).add_to_board_at    [4,2]
    (Pawn.new(self, player)).add_to_board_at    [5,2]
    (Pawn.new(self, player)).add_to_board_at    [6,2]
    (Pawn.new(self, player)).add_to_board_at    [7,2]
    (Pawn.new(self, player)).add_to_board_at    [8,2]

    # add player 2 (top) pieces
    player = @player2
    (Rook.new(self, player)).add_to_board_at    [1,8]
    (Knight.new(self, player)).add_to_board_at  [2,8]
    (Bishop.new(self, player)).add_to_board_at  [3,8]
    (King.new(self, player)).add_to_board_at    [4,8]
    (Queen.new(self, player)).add_to_board_at   [5,8]
    (Bishop.new(self, player)).add_to_board_at  [6,8]
    (Knight.new(self, player)).add_to_board_at  [7,8]
    (Rook.new(self, player)).add_to_board_at    [8,8]

    (Pawn.new(self, player)).add_to_board_at    [1,7]
    (Pawn.new(self, player)).add_to_board_at    [2,7]
    (Pawn.new(self, player)).add_to_board_at    [3,7]
    (Pawn.new(self, player)).add_to_board_at    [4,7]
    (Pawn.new(self, player)).add_to_board_at    [5,7]
    (Pawn.new(self, player)).add_to_board_at    [6,7]
    (Pawn.new(self, player)).add_to_board_at    [7,7]
    (Pawn.new(self, player)).add_to_board_at    [8,7]
  end


end
