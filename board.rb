require_relative 'changeunit'

class Board
  include ChangeUnit

  attr_reader :larger_board_array, :side_board_array
  attr_accessor :unknown_code_array

  def initialize(game_mode, change_array = [])
    @larger_board_array = Array.new(12) { Array.new(4, '.') }
    @side_board_array   = Array.new(12) { Array.new(4, '.') }
    @game_mode = game_mode
    case game_mode
    when 'maker'
      @unknown_code_array = ChangeUnit.change_array_color(change_array, Array.new(4, '.'), true)
    when 'breaker'
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
    @unknown_code_array.each { |question_mark| print "#{question_mark}\s" }
    print "\n"
    puts "\n"
  end
end
