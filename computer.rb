require_relative 'changeunit'

class Computer
  include ChangeUnit

  attr_accessor :guess
  attr_reader :set

  def initialize
    @set = ('1111'..'6666').to_a
    unwanted_subset = @set.select { |number| set_includes_numbers_that_are_not_wanted?(number) }
    @set = @set - unwanted_subset
    @feedback_array = Array.new(4, '')
    @color_code = ''
    @guess = ''
  end

  def set_includes_numbers_that_are_not_wanted?(number)
    number.include?('0') || number.include?('7') || number.include?('8') || number.include?('9') 
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
      ChangeUnit.set_feedback = []
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
