# frozen_string_literal: true

require "minitest/autorun"

class Day
  attr_accessor :cards

  Card = Struct.new(:id, :winning_numbers, :your_numbers, :extra_copies) do
    def matches
      winning_numbers & your_numbers
    end

    def score
      matches.empty? ? 0 : 2**(matches.size - 1)
    end

    def instances
      1 + extra_copies
    end
  end

  def initialize
    @cards = []
  end

  def parse_cards(data)
    @cards = data.each_line.with_object([]) do |line, a|
      line = line.chomp
      card_label, game = line.split(": ")
      id = card_label.split(" ").last.to_i
      win_nums, you_nums = game.split(" | ").map { |x| x.split(" ").map(&:to_i) }
      a << Card.new(id, win_nums, you_nums, 0)
    end

    cards.each do |card|
      card.matches.size.times do |i|
        next_id = card.id + i + 1
        next_card = card_by_id(next_id)
        break if next_card.nil?

        next_card.extra_copies += (1 * card.instances)
      end
    end
  end

  def result_part_a
    cards.map(&:score).sum
  end

  def result_part_b
    cards.sum(&:instances)
  end

  def card_by_id(id)
    cards.find { |card| card.id == id }
  end

  class DayTest < Minitest::Test
    def test_cards
      data = <<~DATA
        Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
      DATA

      runner = Day.new
      cards = runner.parse_cards(data)
      assert_equal(6, cards.size)

      card_two = cards[1]
      assert_equal(2, card_two.id)
      assert_equal([13, 32, 20, 16, 61], card_two.winning_numbers)
      assert_equal([61, 30, 68, 82, 17, 32, 24, 19], card_two.your_numbers)

      card_three = cards[2]
      assert_equal(3, card_three.id)
      assert_equal([1, 21, 53, 59, 44], card_three.winning_numbers)
      assert_equal([69, 82, 63, 72, 16, 21, 14, 1], card_three.your_numbers)

      assert_equal(8, cards[0].score)
      assert_equal(2, card_two.score)
      assert_equal(2, card_three.score)
      assert_equal(1, cards[3].score)
      assert_equal(0, cards[4].score)
      assert_equal(0, cards[5].score)

      assert_equal(13, runner.result_part_a)
    end

    def test_copies
      data = <<~DATA
        Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
      DATA

      runner = Day.new
      cards = runner.parse_cards(data)
      assert_equal(cards[0], runner.card_by_id(1))
      assert_equal(1, cards[0].instances)
      assert_equal(2, cards[1].instances)
      assert_equal(4, cards[2].instances)
      assert_equal(8, cards[3].instances)
      assert_equal(14, cards[4].instances)
      assert_equal(1, cards[5].instances)
      assert_equal(30, runner.result_part_b)
    end
  end
end

runner = Day.new
runner.parse_cards(File.read(File.join(__dir__, "input.dat")))

puts "Part A is #{runner.result_part_a}"
puts "Part B is #{runner.result_part_b}"
