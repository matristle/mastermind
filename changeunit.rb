require 'colorize'

module ChangeUnit
  @@feedback_array = []

  def self.get_other_feedback
    @@feedback_array
  end

  def self.set_feedback=(feedback_array)
    @@feedback_array = feedback_array
  end

  def self.change_array_color(change_combo_array, dot_array, main_peg_mode)
    if main_peg_mode
      change_combo_array.map!(&:to_s)
      change_combo_array.map!(&:to_sym)

      dot_array.map!.with_index { |dot, index| dot.colorize(change_combo_array[index]) }
    else
      change_combo_array.length.times do |index|
        dot_array[index] = dot_array[index].colorize(change_combo_array[index])
      end
    end
    (4 - change_combo_array.length).times { dot_array.pop }
    (4 - change_combo_array.length).times { dot_array.push('') }

    dot_array
  end

  def self.get_and_rectify_input
    gets.chomp.strip
              .delete(":[]''")
              .split(',')
              .map(&:strip)
              .map(&:to_sym)
  end

  def self.show_dots(dot_array)
    dot_array.each { |dot| print "#{dot}\s" }
    print "\n"
  end

  def self.the_six_colors
    [:red,:magenta,:yellow,:green,:blue,:cyan]
  end

  def self.feedback_colors
    [:white,:red]
  end

  def self.show_colors(with_sentence = false)
    puts 'The available colors are:' if with_sentence
    ChangeUnit.the_six_colors.each { |color| print color.to_s; print "\n" }
  end

  def self.make_other_feedback(your_code, set_element_code)
    @@feedback = []
    your_code_clone = []
    set_element_code_clone = [] 

    your_code.each_with_index { |element, index| your_code_clone[index] = element }
    set_element_code.each_with_index { |element, index| set_element_code_clone[index] = element }

    set_element_code_clone.length.times do |index|
      if your_code_clone[index] == set_element_code_clone[index] && !(your_code_clone[index].nil? || set_element_code_clone[index].nil?)
        @@feedback_array.push(:red) 
        your_code_clone[index] = nil
        set_element_code_clone[index] = nil
      end
    end

    your_code_clone.each_with_index do |choice_element, index|
      set_element_code_clone.each_with_index do |code_element, ind|
        if choice_element == code_element && !(choice_element.nil? || code_element.nil?)
          @@feedback_array.push(:white)
          your_code_clone[index] = nil
          set_element_code_clone[ind] = nil
        end
      end
    end
  end
  
  def fun!
    loop do
      fun_array = Array.new(Random.rand(60).floor, '.'.colorize(String.colors.sample))
      fun_array.each { |dot| print dot }
      print "\n"
    end
  end
end
