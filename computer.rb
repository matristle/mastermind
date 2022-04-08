require 'colorize'

require_relative 'changeunit'

class Computer
  include ChangeUnit

  attr_accessor :guess

  def initialize
    @set = ('1111'..'6666').to_a
    @set.each_with_index do |_, index|  
      if @set[index].include?('0') || @set[index].include?('7') || @set[index].include?('8') || @set[index].include?('9')
        @set[index] = nil
      end
    end
    @set.delete(nil)
    @f_array = Array.new(4, '')
    @color_code = ''
    @guess = ''
  end

  def self.num_to_color(guess)
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

  def diff_response_purge(feedback)
    feedback.delete(nil)
    ind = 0
    until @set[ind] == nil
      unless @set[ind] == nil
        @color_code = Computer.num_to_color(@set[ind])
        ChangeUnit.make_other_feedback(@guess, @color_code)
        @color_code.delete(nil)
        unless ChangeUnit.get_other_feedback.sort == feedback.sort
          @set.delete_at(ind) 
          ind -= 1
        end
        ind += 1
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
