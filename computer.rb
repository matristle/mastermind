require_relative 'changeunit'

class Computer
  include ChangeUnit

  attr_accessor :guess

  def initialize
    @set = ('1111'..'6666').to_a
    @set.each_index do |index| 
      set_includes_numbers_that_are_not_wanted = @set[index].include?('0') || @set[index].include?('7') || @set[index].include?('8') || @set[index].include?('9') 

      if set_includes_numbers_that_are_not_wanted
        @set[index] = nil
      end
    end
    @set.delete(nil)
    @feedback_array = Array.new(4, '')
    @color_code = ''
    @guess = ''
  end

  def self.number_to_color(guess)
    guess.split('').each do |number|
      case number
      when '1'
        guess.sub!(number,'red,')
      when '2'
        guess.sub!(number,'magenta,')
      when '3'
        guess.sub!(number,'yellow,')
      when '4'
        guess.sub!(number,'green,')
      when '5'
        guess.sub!(number,'blue,')
      when '6'
        guess.sub!(number,'cyan,')
      end
    end
    guess.split(',').map(&:to_sym)
  end

  def different_response_purge(feedback)
    feedback.delete(nil)
    index = 0
    until @set[index] == nil
      unless @set[index] == nil
        @color_code = Computer.number_to_color(@set[index])
        ChangeUnit.make_other_feedback(@guess, @color_code)
        @color_code.delete(nil)
        unless ChangeUnit.get_other_feedback.sort == feedback.sort
          @set.delete_at(index) 
          index -= 1
        end
        index += 1
      end
    end
    @set
  end

  def pick_first
    @guess = @set.first.split(',')
    @set.delete(@set.first)
    @guess
  end

  def delete(number)
    @set.delete(number)
  end
end
