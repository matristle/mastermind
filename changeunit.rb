require 'colorize'

module ChangeUnit
  @@f_array = []

  def self.get_other_feedback
    @@f_array
  end

  def self.set_feedback=(feed)
    @@f_array = feed
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
              .strip
              .split(',')
              .map(&:strip)
              .map(&:to_sym)
  end

  def self.show_dots(dot_array)
    dot_array.each {|dot| print "#{dot}\s"}
    print "\n"
  end

  def self.the_six_colors
      [:red,:magenta,:yellow,:green,:blue,:cyan]
  end

  def self.show_colors(without_sentence = '')
    puts 'The available colors are:' if without_sentence == 'without sentence'
    ChangeUnit.the_six_colors.each { |color| print color.to_s; print "\n" }
  end

  def self.make_other_feedback(yc_array, cc_array, f_array = [])
    temp_yc = []
    temp_cc = [] 

    yc_array.each_with_index { |element, index| temp_yc[index] = element }
    cc_array.each_with_index { |element, index| temp_cc[index] = element }

    temp_cc.length.times do |index|
      if temp_yc[index] == temp_cc[index] && !(temp_yc[index].nil? || temp_cc[index].nil?)
        f_array.push(:red) 
        temp_yc[index] = nil
        temp_cc[index] = nil
      end
    end

    temp_yc.each_with_index do |choice_el, index|
      temp_cc.each_with_index do |code_el, ind|
        if choice_el == code_el && !(choice_el.nil? || code_el.nil?)
          f_array.push(:white)
          temp_yc[index] = nil
          temp_cc[ind] = nil
        end
      end
    end
    ChangeUnit.set_feedback = f_array
  end
  
  def fun!
    loop do
      fun_array = Array.new(Random.rand(40).floor, '.'.colorize(String.colors.sample))
      fun_array.each { |dot| print dot }
      print "\n"
    end
  end
end
