require 'colorize'

require_relative 'changeunit'
require_relative 'code'
require_relative 'board'
require_relative 'computer'

puts "\s\sSo, do you want to be the Code Breaker, or Code Maker?"

while "The user doesn't include a valid mode"
  breaker_or_maker_answer = gets.chomp

  if breaker_or_maker_answer.downcase.include?('breaker') || breaker_or_maker_answer.downcase.include?('maker')
    break
  else
    puts "\s\sPlease mention the mode that you want to play in (Code Breaker or Code Maker)"
  end
end

if breaker_or_maker_answer.downcase.include?('maker')
  puts "\s\sOkay! Code Maker it is."
  puts "\s\sMake your color code guess like so: color 1, color 2, color 3, color 4 (repetition is allowed)"
  ChangeUnit.show_colors(ChangeUnit.the_six_colors)
  print "\n"
  while "The user doesn't include a valid color code"
    your_chosen_color_code = ChangeUnit.get_and_rectify_input
    colors_with_string_elements = ChangeUnit.the_six_colors.map(&:to_s)
    your_chosen_color_code_with_string_elements = your_chosen_color_code.map(&:to_s)

    if your_chosen_color_code_with_string_elements.all?{ |color| colors_with_string_elements.include?(color) } 
      break
    else
      puts "\s\sFollow this format using the available six colors: color 1,color 2,color 3,color 4 (repetition is allowed)"
      ChangeUnit.show_colors(ChangeUnit.the_six_colors)
      print "\n"
    end
  end

  board = Board.new('maker', your_chosen_color_code)
  computer = Computer.new
  print "\n"
  puts "The feedback rules:"
  print "\n"
  sleep 2
  puts 'Red - if colors are in the same position of both sequences'
  sleep 4
  puts 'White - if colors are available in both sequences but not in the same position'
  sleep 4
  puts 'Leave empty - if the above conditions are not met'
  sleep 6
  print "\n"
  puts "Following the first rule and the computer's goal being to guess the sequence, a feedback sequence of 4 Reds wins the game"
  sleep 4
  puts "\n"
  puts "\n"
  puts "Those said, let's see if the computer can crack your code!"
  print "\n"

  board.larger_board_array.each_index do |index|
    if index.zero?
      computer.guess = Computer.number_to_color('1122')
      ChangeUnit.change_array_color(computer.guess, board.larger_board_array[index], true) 
    else
      ChangeUnit.change_array_color(computer.pick_first, board.larger_board_array[index], true) 
    end
    board.show
    puts 'Provide feedback using this format: color 1,color 2,color 3,color 4 (repetition is allowed and the order does not matter)'
    print "\n"
    while "The user doesn't include a valid feedback"
      your_feedback_array = ChangeUnit.get_and_rectify_input
      if your_feedback_array.all?{ |feedback_color| ChangeUnit.feedback_colors.include?(feedback_color) } 
        break
      else
        print "\n"
        puts "\s\sFollow this format using the available six colors: color 1,color 2,color 3,color 4 (repetition is allowed and the order does not matter)"
        ChangeUnit.show_colors(ChangeUnit.feedback_colors)
      end
    end
    print "\n"
    ChangeUnit.change_array_color(your_feedback_array, board.side_board_array[index], false)
    board.show

    four_reds = your_feedback_array.count(:red) == 4
    if four_reds
      puts '¯\_(ツ)_/¯ Computer guessed your code ¯\_(ツ)_/¯'
      print "\n"
      sleep 7
      puts '...or you gave 4 reds for the wrong code ;)'
      break
    else
      computer.different_response_purge(your_feedback_array)
    end
  end
elsif breaker_or_maker_answer.downcase.include?('breaker')
  ChangeUnit.show_colors(ChangeUnit.the_six_colors)
  print "\n"
  puts "The feedback rules:"
  print "\n"
  sleep 2
  puts 'Red - if colors are in the same position of both sequences'
  sleep 4
  puts 'White - if colors are available in both sequences but not in the same position'
  sleep 4
  puts 'Leave empty - if the above conditions are not met'
  sleep 6
  print "\n"
  puts "Following the first rule and the computer's goal being to guess the sequence, a feedback sequence of 4 Reds win the game"
  sleep 4
  puts "\n"
  puts "\n"
  puts "\s\sReady to break some code? (Y/N)"
  sleep 4
  puts "Got you there! No input required! :D"
  print "\n"
  sleep 2
  hidden_code = Code.new
  board = Board.new('breaker')
  board.show
  board.larger_board_array.each_index do |index|
    puts "\s\sEnter a color sequence to guess the code using this format: color 1, color 2, color 3, color 4 (repetition is allowed)"
    while "The user doesn't include a valid color sequence"
      choice_array = ChangeUnit.get_and_rectify_input
      colors_with_string_elements = ChangeUnit.the_six_colors.map(&:to_s)
      choice_array_with_string_elements = choice_array.map(&:to_s)
      if choice_array_with_string_elements.all?{ |color| colors_with_string_elements.include?(color) } 
        break
      else
        print "\n"
        puts "\s\sFollow this format using the available six colors: color 1,color 2,color 3,color 4 (repetition is allowed)"
        ChangeUnit.show_colors(ChangeUnit.the_six_colors)
      end
    end
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
puts 'Thank you for playing my Mastermind!'



