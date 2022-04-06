require 'colorize'

require_relative 'changeunit'
require_relative 'code'
require_relative 'board'
require_relative 'computer'

puts 'So, do you want to be the Code Breaker, or Code Maker?'
sides_answer = gets.chomp

if sides_answer.downcase.include?('maker')
  puts 'Okay! Code Maker it is.'
  puts 'Make your color code guess like so: color1, color2, color3, color4 (repetition is allowed)'
  puts 'The available colors are:'
  ChangeUnit.show_colors
  your_chosen_color_code = gets.chomp.strip
  your_chosen_color_code.delete!(":[]''")
  your_chosen_color_code.strip!
  your_chosen_color_code = your_chosen_color_code.split(',')
  your_chosen_color_code.map!(&:strip)
  your_chosen_color_code.map!(&:to_sym)
  board = Board.new('maker', your_chosen_color_code)
  comp = Computer.new

  board.larger_board_array.each_with_index do |_, index|
    if index.zero?
      comp.guess = Computer.num_to_color('1122')
      ChangeUnit.change_array_color(comp.guess, board.larger_board_array[index], true) 
    else
      ChangeUnit.change_array_color(comp.pick_first, board.larger_board_array[index], true) 
    end
    board.show
    puts 'Give a feedback array using this format: color1, color2, color3, color4 (repetition is allowed) '
    your_feedback_array = gets.chomp

    your_feedback_array.delete! ":[]''"
    your_feedback_array = your_feedback_array.split(',')
    your_feedback_array.map!(&:strip)
    your_feedback_array.map!(&:to_sym)
    print "\n"
    ChangeUnit.change_array_color(your_feedback_array, board.side_board_array[index], false)
    board.show

    if your_feedback_array.count(:red) == 4
      puts '¯\_(ツ)_/¯ Computer guessed your code ¯\_(ツ)_/¯'
      print "\n"
      break
    else
      comp.diff_response_purge(your_feedback_array)
    end
  end
elsif sides_answer.downcase.include?('breaker')
  puts "Let's break some code!"
  puts 'Make your color code guess like so: color1, color2, color3, color4 (repetition is allowed)'
  puts 'The available colors are:'
  ChangeUnit.show_colors
  hidden_code = Code.new
  board = Board.new('breaker')
  board.show
  board.larger_board_array.each_with_index do |_, index|
    puts 'Enter color combo array using this format: color1, color2, color3, color4 (repetition is allowed)'
    print "\n"
    choice_array = gets.chomp
    choice_array.delete! ":[]''"
    choice_array = choice_array.split(',')
    choice_array.map!(&:strip)
    choice_array.map!(&:to_sym)
    print "\n"
    ChangeUnit.change_array_color(choice_array, board.larger_board_array[index], true)
    hidden_code.check_for_similarities(board.larger_board_array[index])
    ChangeUnit.change_array_color(hidden_code.feedback_array, board.side_board_array[index], false)
    board.show
    if hidden_code.feedback_array.count(:red) == 4 
      board.unknown_code_array = board.larger_board_array[index]
      board.show
      puts "Code cracked!"
      sleep 2.5
      board.fun!
    elsif board.larger_board_array[index] == board.larger_board_array.length && hidden_code.feedback_array.count(:red) != 4 
      board.unknown_code_array = hidden_code.code_array
      puts 'Better luck on your next try!'
    end
    hidden_code.feedback_array = []
  end
end

board.show

