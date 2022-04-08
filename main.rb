require 'colorize'

require_relative 'changeunit'
require_relative 'code'
require_relative 'board'
require_relative 'computer'

puts 'So, do you want to be the Code Breaker, or Code Maker?'
breaker_or_maker_answer = gets.chomp

if breaker_or_maker_answer.downcase.include?('maker')
  puts 'Okay! Code Maker it is.'
  puts 'Make your color code guess like so: color1, color2, color3, color4 (repetition is allowed)'
  ChangeUnit.show_colors
  your_chosen_color_code = ChangeUnit.get_and_rectify_input
  board = Board.new('maker', your_chosen_color_code)
  computer = Computer.new

  board.larger_board_array.each_index do |index|
    if index.zero?
      computer.guess = Computer.number_to_color('1122')
      ChangeUnit.change_array_color(computer.guess, board.larger_board_array[index], true) 
    else
      ChangeUnit.change_array_color(computer.pick_first, board.larger_board_array[index], true) 
    end
    board.show
    puts 'Give a feedback array using this format: color1, color2, color3, color4 (repetition is allowed) '
    your_feedback_array = ChangeUnit.get_and_rectify_input
    print "\n"
    ChangeUnit.change_array_color(your_feedback_array, board.side_board_array[index], false)
    board.show

    four_reds = your_feedback_array.count(:red) == 4
    if four_reds
      puts '¯\_(ツ)_/¯ Computer guessed your code ¯\_(ツ)_/¯'
      print "\n"
      break
    else
      computer.different_response_purge(your_feedback_array)
    end
  end
elsif breaker_or_maker_answer.downcase.include?('breaker')
  puts "Let's break some code!"
  puts 'Make your color code guess like so: color1, color2, color3, color4 (repetition is allowed)'
  ChangeUnit.show_colors
  hidden_code = Code.new
  board = Board.new('breaker')
  board.show
  board.larger_board_array.each_index do |index|
    puts 'Enter color sequence using this format: color1, color2, color3, color4 (repetition is allowed)'
    print "\n"
    choice_array = ChangeUnit.get_and_rectify_input
    print "\n"
    ChangeUnit.change_array_color(choice_array, board.larger_board_array[index], true)
    hidden_code.check_for_similarities(board.larger_board_array[index])
    ChangeUnit.change_array_color(hidden_code.feedback_array, board.side_board_array[index], false)
    board.show

    four_reds = hidden_code.feedback_array.count(:red) == 4
    if four_reds 
      board.unknown_code_array = board.larger_board_array[index]
      board.show
      puts "Code cracked!"
      sleep 2.5
      board.fun!
    elsif board.larger_board_array[index] == board.larger_board_array[-1] && !four_reds 
      board.unknown_code_array = hidden_code.code_array
    end
    hidden_code.feedback_array = []
  end
end

board.show
puts 'Better luck on your next try!'



