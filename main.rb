=begin
    
    .  .  .  .  | ....
    .  .  .  .  | ....
    .  .  .  .  | ....
    .  .  .  .  | ....
    .  .  .  .  | ....
    .  .  .  .  | ....
    .  .  .  .  | ....
    .  .  .  .  | ....
    .  .  .  .  | ....
    .  .  .  .  | ....
    .  .  .  .  | ....
    .  .  .  .  | ....


    --------
    ? ? ? ?
    
=end

require 'colorize'

module ChangeUnit
    def self.change_array_color(change_combo_array, dot_array = ['y','o','u','f'], main_peg_mode)
        if main_peg_mode
            dot_array.map!.with_index { |dot, index| dot.colorize(change_combo_array[index]) }
        else
            change_combo_array.length.times.with_index do |index|
                dot_array[index] = dot_array[index].colorize(change_combo_array[index]) 
            end

            (4 - change_combo_array.length).times { dot_array.pop; dot_array.push('')}
        end
    end

    def self.show_dots(dot_array)
        dot_array.each {|dot| print "#{dot}\s"}
        print "\n"
    end
end

class Code
    include ChangeUnit

    attr_reader :feedback_array, :code_color_array # DON'T FORGET TO REMOVE THIS
    
    def initialize
        @code_array = Array.new(4,'.')
        @code_color_array = Array.new
        @feedback_array = Array.new
        4.times { @code_color_array.push(String.colors.sample) }
        ChangeUnit.change_array_color(@code_color_array, @code_array, true)
    end
    
    def check_for_similarities(main_peg_row_array)
        main_peg_row_array.each_with_index do |choice_el, index|
            @feedback_array.push(:red) if main_peg_row_array[index] == @code_array[index]
            @code_array.each_with_index do |code_el|
                @feedback_array.push(:white) if code_el == choice_el && main_peg_row_array[index] != @code_array[index]   
            end
        end
    end

    # private 
    
    def show_code
        @code_array.each {|dot| print "#{dot}\s"}
        print "\n"
    end

end

class Board
    include ChangeUnit

    attr_reader :larger_board_array, :side_board_array
    attr_accessor :unknown_code_array
    
    def initialize(game_mode, change_array = [])
        @larger_board_array = Array.new(12) { Array.new(4,'.') }
        @side_board_array   = Array.new(12) { Array.new(4,'.') }
        @game_mode = game_mode
        if game_mode == 'maker' 
            @unknown_code_array = ChangeUnit.change_array_color(change_array, Array.new(4,'.'), true)
        elsif game_mode == 'breaker'
            @unknown_code_array = Array.new(4, '?')
        end
    end

    def show
      
        @larger_board_array.each_with_index do |row_main, index|
            row_main.each do |dot_main|
                print dot_main + "\s\s"
            end

            print "|\s"

            @side_board_array[index].each do |dot_side|
                print dot_side
            end
            
            print "\n"
        end
        
        2.times { print "\n" }
        
        puts "\s\s\s---------"
        
        print "\s\s\s\s"
        @unknown_code_array.each {|question_mark| print "#{question_mark}\s"}
        print "\n"
        puts "\n"

    end

    def pick_color(choice_combo_array)
        
    end
end

class Computer
    include ChangeUnit

    def initialize; end

    def evaluate
    end


    

end

#-------------------------------------------------------------

puts "So, do you want to be the Code Breaker, or Code Maker?"

sides_answer = gets.chomp

if sides_answer.downcase.include?('maker') 
    puts "Okay! Code Maker it is."
    puts "Make your color code and store each :color as an element in an array."
    puts "The available colors are:"
    String.colors.each { |color| p color }
    your_chosen_color_code = gets.chomp
    your_chosen_color_code.delete! ":[]''"
    your_chosen_color_code = your_chosen_color_code.split(',')
    your_chosen_color_code.map! { |symbol_string| symbol_string.to_sym }
    board = Board.new('maker', your_chosen_color_code)
    board.show
    puts "The available colors are:"
    String.colors.each { |color| p color }

elsif sides_answer.downcase.include?('breaker')
    puts "Let's break some code!"
    hidden_code = Code.new
    board = Board.new('breaker')

    board.larger_board_array.each_with_index do |_, index|
        # hidden_code.code_color_array.each {|code| puts "boop: #{code}"}
        print "Enter color combo array: "
        choice_array = gets.chomp
        choice_array.delete! ":[]''"
        choice_array = choice_array.split(',')
    
        choice_array.map! { |symbol_string| symbol_string.to_sym }
    
        print "\n"
    
        board.larger_board_array[index].each {|el| puts "from board: #{el}"}
        ChangeUnit.change_array_color(choice_array, board.larger_board_array[index], true)
        hidden_code.check_for_similarities(board.larger_board_array[index])
        ChangeUnit.change_array_color(hidden_code.feedback_array, board.side_board_array[index], false)
        board.show
        if board.side_board_array[index].all?(board.side_board_array[index].first) && board.side_board_array[index].first == "\e[0;31;49m.\e[0m"
            board.unknown_code_array = board.larger_board_array[index]
            break
        end
    end
end


# [:yellow,:cyan,:red,:blue]