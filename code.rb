require_relative 'changeunit'

class Code
  include ChangeUnit
  attr_accessor :feedback_array
  attr_reader :code_color_array, :code_array

  def initialize
    @code_array = Array.new(4,'.') # ['colored point 1', 'colored point 2', 'colored point 3', 'colored point 4']
    @code_color_array = [] # [color 1, color 2, color 3, color 4]
    @feedback_array = [] # [:red, :white, :white, :red]
    4.times { @code_color_array.push(ChangeUnit.the_six_colors.sample) }
    ChangeUnit.change_array_color(@code_color_array, @code_array, true)
  end

  def check_for_similarities(main_peg_row_array)
    main_peg_row_array_clone = main_peg_row_array.clone 
    code_array_clone = @code_array.clone

    code_array_clone.length.times do |index|
      if main_peg_row_array_clone[index] == code_array_clone[index] && !(main_peg_row_array_clone[index].nil? || code_array_clone[index].nil?)
        @feedback_array.push(:red)
        main_peg_row_array_clone[index] = nil
        code_array_clone[index] = nil
      end
    end

    main_peg_row_array_clone.each_with_index do |choice_element, choice_index|
      code_array_clone.each_with_index do |code_element, code_index|
        if choice_element == code_element && !(choice_element.nil? || code_element.nil?)
          @feedback_array.push(:white)
          main_peg_row_array_clone[choice_index] = nil
          code_array_clone[code_index] = nil
        end
      end
    end
  end
  
  def show_code
    @code_array.each { |dot| print "#{dot}\s" }
    print "\n"
  end
end
