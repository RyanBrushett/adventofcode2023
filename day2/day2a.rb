# frozen_string_literal: true

require "minitest/autorun"

class DayTwoA
  Game = Struct.new(:id, :rounds)
  GameRound = Struct.new(:red, :green, :blue)

  def parse(data)
    games = []
    data.each_line do |line|
      game_label, game_actions = line.chomp.split(": ")
      game_id = game_label.split(" ").last.to_i
      rounds = game_actions.split("; ")
      parsed_rounds = rounds.map { |round| parse_round(round) }
      games << Game.new(game_id, parsed_rounds)
    end
    games
  end

  def parse_round(round)
    gr = GameRound.new(0, 0, 0)
    round.split(", ").each do |result|
      count, colour = result.split(" ")
      gr[colour] = count.to_i
    end
    gr
  end

  def solve_part_a(games)
    result = games.each_with_object([]) do |game, list|
      next if game.rounds.any? { |round| round.red > 12 || round.green > 13 || round.blue > 14 }

      list << game.id
    end

    result.sum
  end

  def solve_part_b(games)
    result = games.each_with_object([]) do |game, list|
      list << game.rounds.map(&:red).max * game.rounds.map(&:green).max * game.rounds.map(&:blue).max
    end

    result.sum
  end

  class DayTwoATest < Minitest::Test
    def test_parsing_some_input_data
      data = <<~DATA
        Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
      DATA

      runner = DayTwoA.new
      games = runner.parse(data)

      assert_equal(3, games.size)
      game_one = games.find { |g| g.id == 1 }
      assert_equal(3, game_one.rounds.size)
      assert_equal(4, game_one.rounds[0].red)
    end

    def test_parse_rounds
      runner = DayTwoA.new
      text_round = "3 blue, 4 red, 5 green"
      round = runner.parse_round(text_round)
      assert_equal(3, round.blue)
      assert_equal(4, round.red)
      assert_equal(5, round.green)
    end

    def test_solver_part_a
      runner = DayTwoA.new
      data = <<~DATA
        Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
      DATA

      games = runner.parse(data)
      assert_equal(8, runner.solve_part_a(games))
    end

    def test_solver_part_b
      runner = DayTwoA.new
      data = <<~DATA
        Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
      DATA

      games = runner.parse(data)
      assert_equal(2286, runner.solve_part_b(games))
    end
  end
end

runner = DayTwoA.new
games = runner.parse(File.read(File.join(__dir__, "input.dat")))

puts "Part A is #{runner.solve_part_a(games)}"
puts "Part B is #{runner.solve_part_b(games)}"
