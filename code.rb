require 'colorize'

require_relative 'changeunit'

class Code
  include ChangeUnit
  attr_accessor :feedback_array
  attr_reader :code_color_array, :code_array

  def initialize
    @code_array = Array.new(4,'.')
    @code_color_array = []
    @feedback_array = []
    4.times { @code_color_array.push(ChangeUnit.the_six_colors.sample) }
    ChangeUnit.change_array_color(@code_color_array, @code_array, true)
  end

  def check_for_similarities(main_peg_row_array)
    temp_mpr = []
    temp_c = []

    main_peg_row_array.each_with_index { |element, index| temp_mpr[index] = element }
    @code_array.each_with_index {|element, index| temp_c[index] = element}

    temp_c.length.times do |index|
      if temp_mpr[index] == temp_c[index] && !(temp_mpr[index].nil? || temp_c[index].nil?)
        @feedback_array.push(:red)
        temp_mpr[index] = nil
        temp_c[index] = nil
      end
    end

    temp_mpr.each_with_index do |choice_el, index|
      temp_c.each_with_index do |code_el, ind|
        if choice_el == code_el && !(choice_el.nil? || code_el.nil?)
          @feedback_array.push(:white)
          temp_mpr[index] = nil
          temp_c[ind] = nil
        end
      end
    end
  end
  
  def show_code
    @code_array.each {|dot| print "#{dot}\s"}
    print "\n"
  end
end
