# frozen_string_literal: true

require "minitest/autorun"

class DayOneB
  SPELLED_OUT = { one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9 }

  def run
    calibration_values = []
    File.foreach(File.join(__dir__, "input.dat")).each_entry do |line|
      calibration_values.push(*process(line))
    end

    calibration_values.each_slice(2).map { |x| x.join("").to_i }.sum
  end

  def process(line)
    first_spelled_indices = {}
    last_spelled_indices = {}
    first_digit_indices = {}
    last_digit_indices = {}

    scrubbed = line.tr("^0-9", "").split("")
    first_integer_digit = scrubbed.first
    last_integer_digit = scrubbed.last

    first_digit_indices[first_integer_digit] = line.index(first_integer_digit) unless first_integer_digit.nil?
    last_digit_indices[last_integer_digit] = line.rindex(last_integer_digit) unless last_integer_digit.nil?

    SPELLED_OUT.each do |dig_sym, _number|
      string_digit = dig_sym.to_s
      if line.include?(string_digit)
        first_spelled_indices[dig_sym] = line.index(string_digit)
        last_spelled_indices[dig_sym] = line.rindex(string_digit)
      end
    end

    smin = first_spelled_indices.min_by { |_k, v| v }
    smax = last_spelled_indices.max_by { |_k, v| v }
    smin = { SPELLED_OUT[smin.first] => smin.last } unless smin.nil?
    smax = { SPELLED_OUT[smax.first] => smax.last } unless smin.nil?

    candidates = [smin, smax, first_digit_indices, last_digit_indices].compact.delete_if(&:empty?)
    lowest = candidates.sort_by(&:values).first
    highest = candidates.sort_by(&:values).last

    [lowest.keys.first.to_i, highest.keys.first.to_i]
  end

  class DayOneBTest < Minitest::Test
    def test_simple_lines
      input = "eight2eight"
      runner = DayOneB.new
      out = runner.process(input)

      assert_equal([8, 8], out)
    end

    def test_some_more
      input = "12345"
      runner = DayOneB.new
      out = runner.process(input)
      assert_equal([1, 5], out)
    end

    def test_even_more_wow
      line = "onetwothree"
      runner = DayOneB.new
      out = runner.process(line)
      assert_equal([1, 3], out)
    end

    def test_more_simple_lines
      input = "1three1"
      runner = DayOneB.new
      out = runner.process(input)
      assert_equal([1, 1], out)
    end

    def test_something_longer
      input = "4nineeightseven2"
      runner = DayOneB.new
      out = runner.process(input)
      assert_equal([4, 2], out)
    end
  end
end

puts DayOneB.new.run
