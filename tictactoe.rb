class Player

  attr_reader :name, :mark

  def initialize(name, mark)
    @name = name
    @mark = mark
  end

end

class Board

  attr_accessor :grid

  def initialize
    @grid =
      [
        [" ", " ", " "], #1 => [0][0], 2 => [0][1], 3 => [0][2]
        [" ", " ", " "], #4 => [1][0], 5 => [1][1], 6 => [1][2]
        [" ", " ", " "]  #7 => [2][0], 8 => [2][1], 9 => [2][2]
      ]
  end

  def rows
    @grid
  end

  def columns
    [
      [@grid[0][0], @grid[1][0], @grid[2][0]],
      [@grid[0][1], @grid[1][1], @grid[2][1]],
      [@grid[0][2], @grid[1][2], @grid[2][2]]
    ]
  end

  def diagonals
    [
      [@grid[0][0], @grid[1][1], @grid[2][2]],
      [@grid[2][0], @grid[1][1], @grid[0][2]]
    ]
  end

end

class Game

  attr_reader :player, :starting_player

  def initialize
    @board = Board.new
    @player = get_player
    @computer_mark = set_opposite_mark
    @starting_player = "player"
    @winner = ""
    @game_over = false
    @tie_game = false
    @player_win_count = 0
    @computer_win_count = 0
  end

  def setup
    clean_term
    show_instructions
    randomize_start_order
    sleep 0.5
    press_to_start
  end

  def reset
    @game_over = false
    @tie_game = false
    @board.grid = [[" ", " ", " "],[" ", " ", " "],[" ", " ", " "]]
    setup
  end

  def play
    until @game_over do
      @starting_player == "player" ? player_start : computer_start
    end
    check_victory_type
    play_again?
  end

  def check_victory_type
    @tie_game ? end_draw_game : announce_winner
  end

  def check_victory_conditions
    detect_win
    detect_draw
  end

  def player_start
    sleep 1
    user_turn_actions
    if @game_over == false
      computer_thinking_time
      computer_turn_actions
    end
  end

  def computer_thinking_time
    waiting
    sleep 2.5
  end

  def computer_start
    computer_thinking_time
    computer_turn_actions
    if @game_over == false
      sleep 1
      user_turn_actions
    end
  end

  def press_to_start
    puts "Press enter to begin"
    user_input = gets.chomp
  end

  def user_turn_actions
    place_user_mark
    clean_term
    prompt_action(player.name)
    show_board
    check_victory_conditions
  end

  def computer_turn_actions
    clean_term
    place_computer_mark
    prompt_action("Computer")
    show_board
    check_victory_conditions
  end

  def check_open_spaces
    @board.rows.flatten.include? " "
  end

  def detect_win
    if detect_three_in_line(@board.rows) || detect_three_in_line(@board.columns) || detect_three_in_line(@board.diagonals)
      @game_over = true
    end
  end

  def detect_draw
    if @game_over || check_open_spaces
      return false
    else
      @game_over = true
      @tie_game = true
    end
  end

  def end_draw_game
    puts "Game is tied!"
  end

  def randomize_start_order
    random = rand(0..1)
    random == 0 ? @starting_player : @starting_player = "computer"
    puts "Randomizing start order..."
  end

  def get_player
    puts "What is your name?"
    name = gets.chomp
    puts "What mark do you want? X or O?"
    mark = gets.chomp.downcase
    verify_player(name, mark)
  end

  def verify_player(name, mark)
    until mark == "x" || mark == "o" do
      puts "Please put either a X or O."
      mark = gets.chomp.downcase
    end
    return Player.new(name, mark)
  end

  def set_opposite_mark
    @player.mark == "x" ? "o" : "x"
  end

  def clean_term
    puts "\e[H\e[2J"
  end

  def show_instructions
    puts "* Welcome to TicTacToe, #{@player.name}! Your mark is #{@player.mark}. The computer mark is #{@computer_mark}. *"
    puts 'Line your marks either horizontally, vertically, or diagonally. First to three in a line wins.'
    puts 'Select a tile with the corresponding number to place your mark.'
    puts ' 1 | 2 | 3 '
    puts '---+---+---'
    puts ' 4 | 5 | 6 '
    puts '---+---+---'
    puts ' 7 | 8 | 9 '
  end

  def prompt_action(name)
    puts "#{name} has placed a mark."
  end

  def show_board
    format = []
    @board.rows.each do |row|
      format << " #{row[0]} | #{row[1]} | #{row[2]} "
      format << "---+---+---"
    end
    format.pop
    puts format
  end

  def valid_move?(tile)
    tile == " "
  end

  def wrong_tile_prompt
    puts "This tile has already been used."
    place_user_mark
  end

  def place_user_mark
    puts "Which tile do you want to place your mark?"
    tile = gets.chomp
    case tile
    when "1"
      valid_move?(@board.grid[0][0]) ? @board.grid[0][0] = "#{@player.mark}" : wrong_tile_prompt
    when "2"
      valid_move?(@board.grid[0][1]) ? @board.grid[0][1] = "#{@player.mark}" : wrong_tile_prompt
    when "3"
      valid_move?(@board.grid[0][2]) ? @board.grid[0][2] = "#{@player.mark}" : wrong_tile_prompt
    when "4"
      valid_move?(@board.grid[1][0]) ? @board.grid[1][0] = "#{@player.mark}" : wrong_tile_prompt
    when "5"
      valid_move?(@board.grid[1][1]) ? @board.grid[1][1] = "#{@player.mark}" : wrong_tile_prompt
    when "6"
      valid_move?(@board.grid[1][2]) ? @board.grid[1][2] = "#{@player.mark}" : wrong_tile_prompt
    when "7"
      valid_move?(@board.grid[2][0]) ? @board.grid[2][0] = "#{@player.mark}" : wrong_tile_prompt
    when "8"
      valid_move?(@board.grid[2][1]) ? @board.grid[2][1] = "#{@player.mark}" : wrong_tile_prompt
    when "9"
      valid_move?(@board.grid[2][2]) ? @board.grid[2][2] = "#{@player.mark}" : wrong_tile_prompt
    else
      puts "Please select a number 1-9 to place your mark."
      place_user_mark
    end
  end

  def waiting
    puts "Waiting for Computer..."
  end

  def place_computer_mark
    coords = randomize_tile
    @board.grid[coords[0]][coords[1]] = @computer_mark
  end

  def randomize_tile
    coords = []
    2.times { coords << rand(0..2) }
    until valid_move?(@board.grid[coords[0]][coords[1]]) do
      coords = []
      2.times { coords << rand(0..2) }
    end
    return coords
  end

  def player_marks
    @player.mark * 3
  end

  def computer_marks
    @computer_mark * 3
  end

  def detect_three_in_line(lines)
    joined_marks = []
    lines.each do |line|
      joined_marks << line.join("")
    end

    if joined_marks.include? player_marks
      @winner = @player.name
      @player_win_count += 1
    elsif joined_marks.include? computer_marks
      @winner = "Computer"
      @computer_win_count += 1
    else
      return false
    end
  end

  def announce_winner
    puts "#{@winner} has won!"
    puts "#{@player.name} Wins: #{@player_win_count} | Computer Wins: #{@computer_win_count}"
  end

  def play_again?
    puts "Play again? Enter Y/N."
    user_input = gets.chomp.downcase
    if user_input == "y"
      reset
      play
    elsif user_input == "n"
      puts "Thanks for playing"
    else
      play_again?
    end
  end
end

game = Game.new
game.setup
game.play