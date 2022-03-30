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

module Code
    @@code_array = Array.new(4,'.')

    def generate_code
        code_color_array = Array.new
        4.times { code_color_array.push(String.colors.sample) }
        @@code_array.map!.with_index { |dot, index| dot.colorize(code_color_array[index]) }
        @@code_array.each {|dot| print "#{dot}\s"}
        print "\n"
    end

    def self.code_array
        @@code_array
    end
end

class Board
    include Code

    def initialize
        @larger_board_array = Array.new(12, Array.new(4,'.'))
        @side_board_array   = Array.new(12, Array.new(4,'.'))
        @unknown_code_array = Array.new(4, '?')

        show
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
    end
end



class Peg; end

class Computer; end

#-------------------------------------------------------------

Board.new
                                      





 




 



