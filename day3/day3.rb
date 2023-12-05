# frozen_string_literal: true

require "minitest/autorun"

class DayThree
  attr_accessor :nums, :syms

  FoundNumber = Struct.new(:number, :x_start, :x_end, :y, :part)
  SchematicSym = Struct.new(:symbol, :x, :y)

  def initialize
    @nums = []
    @syms = []
  end

  def parse_schematic(data)
    data.each_line.with_index do |line, y|
      line.chomp.scan(/\d+/) do
        m = Regexp.last_match
        nums << FoundNumber.new(m[0].to_i, m.begin(0), m.end(0) - 1, y, false)
      end

      line.chomp.scan(/[^.\d]/) do
        m = Regexp.last_match
        syms << SchematicSym.new(m[0], m.begin(0), y)
      end
    end

    set_part_numbers
  end

  def set_part_numbers
    nums.each do |num|
      num.part = true if syms.any? { |sym| adjacent?(num, sym) }
    end
  end

  def gear_ratios
    syms.select { |sym| sym.symbol == "*" }.map do |sym|
      adjacent = nums.select { |num| num.part && adjacent?(num, sym) }
      adjacent.map(&:number).reduce(:*) if adjacent.size == 2
    end.compact.sum
  end

  def part_sum
    nums.select(&:part).map(&:number).sum
  end

  def adjacent?(num, sym)
    sym.x.between?(num.x_start - 1, num.x_end + 1) && sym.y.between?(num.y - 1, num.y + 1)
  end

  class DayThreeTest < Minitest::Test
    def test_parsing_small_inputs
      data = "123..123..123"
      runner = DayThree.new
      runner.parse_schematic(data)
      assert_equal(3, runner.nums.size)
      assert(runner.nums.any? { |num| num.number == 123 && num.x_start == 0 && num.x_end == 2 && num.y == 0 })
      assert(runner.nums.any? { |num| num.number == 123 && num.x_start == 5 && num.x_end == 7 && num.y == 0 })
      assert(runner.nums.any? { |num| num.number == 123 && num.x_start == 10 && num.x_end == 12 && num.y == 0 })
    end

    def test_schematic
      data = <<~DATA
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
      DATA

      runner = DayThree.new
      runner.parse_schematic(data)
      assert(runner.nums.any? { |num| num.number == 467 && num.part == true })
      assert(runner.nums.any? { |num| num.number == 617 && num.part == true })
      assert(runner.nums.any? { |num| num.number == 664 && num.part == true })
      assert(runner.nums.any? { |num| num.number == 114 && num.part == false })
      assert(runner.nums.any? { |num| num.number == 58 && num.part == false })
      assert(4361, runner.part_sum)
    end

    def test_gear_ratios
      data = <<~DATA
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
      DATA

      runner = DayThree.new
      runner.parse_schematic(data)
      assert_equal(467835, runner.gear_ratios)
    end

    def test_left
      data = "..*345.."
      runner = DayThree.new
      runner.parse_schematic(data)
      assert(runner.nums.any? { |num| num.number == 345 && num.part == true })
    end

    def test_right
      data = "..543*.."
      runner = DayThree.new
      runner.parse_schematic(data)
      assert(runner.nums.any? { |num| num.number == 543 && num.part == true })
    end

    def test_up
      data = <<~DATA
        ...*...
        ...3...
        .......
        ..*....
        ...4...
        .......
        ....*..
        ...5...
        .......
        .....*.
        ...6...
      DATA
      runner = DayThree.new
      runner.parse_schematic(data)
      assert(runner.nums.any? { |num| num.number == 3 && num.part == true })
      assert(runner.nums.any? { |num| num.number == 4 && num.part == true })
      assert(runner.nums.any? { |num| num.number == 5 && num.part == true })
      assert(runner.nums.any? { |num| num.number == 6 && num.part == false })
    end

    def test_down
      data = <<~DATA
        ...3...
        ...*...
        .......
        ...4...
        ..*....
        .......
        ...5...
        ....*..
        .......
        ...6...
        .....*.
      DATA
      runner = DayThree.new
      runner.parse_schematic(data)
      assert(runner.nums.any? { |num| num.number == 3 && num.part == true })
      assert(runner.nums.any? { |num| num.number == 4 && num.part == true })
      assert(runner.nums.any? { |num| num.number == 5 && num.part == true })
      assert(runner.nums.any? { |num| num.number == 6 && num.part == false })
    end
  end
end

runner = DayThree.new
runner.parse_schematic(File.read(File.join(__dir__, "input.dat")))
puts "Part A is #{runner.part_sum}"
puts "Part B is #{runner.gear_ratios}"
