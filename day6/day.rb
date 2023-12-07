# frozen_string_literal: true

require "minitest/autorun"

class Day
  Race = Struct.new(:time, :record_distance) do
    def ways_to_win
      # (0..time).map do |time_held|
      #   # quadratic equation here
      #   distance = time_held * (time - time_held)
      #   time_held if distance > record_distance
      # end.compact.size

      disc = time**2 - 4 * (record_distance + 1) # d + 1: we're looking for the min int value above the record
      root_disc = Math.sqrt(disc)
      min_hold = (time - root_disc) / 2
      max_hold = (time + root_disc) / 2
      max_hold.floor - min_hold.ceil + 1
    end
  end

  def initialize
    @races = []
  end

  def parse_races_part_a(data)
    @races = []
    data.each_line do |line|
      if line =~ /Time:/
        line.chomp.split(/\s+/).each do |time_val|
          next unless time_val =~ /\d+/

          @races << Race.new(time_val.to_i, nil)
        end
      elsif line =~ /Distance:/
        line.chomp.split(/\s+/).each_with_index do |distance_val, index|
          @races[index - 1].record_distance = distance_val.to_i
        end
      end
    end

    @races
  end

  def parse_races_part_b(data)
    @races = []
    time = 0
    record_distance = 0
    data.each_line do |line|
      val = line.scan(/\d+/).join("").to_i
      time = val if line.include?("Time:")
      record_distance = val if line.include?("Distance:")
    end

    @races << Race.new(time, record_distance)
  end

  def result
    @races.map(&:ways_to_win).reduce(:*)
  end

  class DayTest < Minitest::Test
    def test_some_test_input
      data = <<~DATA
        Time:      7  15   30
        Distance:  9  40  200
      DATA

      runner = Day.new
      races = runner.parse_races_part_a(data)
      assert_equal(3, races.size)
      race = races.first
      assert_equal(7, race.time)
      assert_equal(9, race.record_distance)
      assert_equal(4, race.ways_to_win)

      [4, 8, 9].each_with_index do |expected, i|
        assert_equal(expected, races[i].ways_to_win)
      end

      assert_equal(288, runner.result)
    end

    def test_some_test_input_part_b
      data = <<~DATA
        Time:      7  15   30
        Distance:  9  40  200
      DATA

      runner = Day.new
      races = runner.parse_races_part_b(data)
      assert_equal(1, races.size)
      race = races.first
      assert_equal(71530, race.time)
      assert_equal(940200, race.record_distance)
      assert_equal(71503, race.ways_to_win)
    end
  end
end

runner = Day.new
input_data = File.read(File.join(__dir__, "input.dat"))

runner.parse_races_part_a(input_data)
puts "Part A: #{runner.result}"

runner.parse_races_part_b(input_data)
puts "Part B: #{runner.result}"
