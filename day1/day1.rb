# frozen_string_literal: true

class DayOne
  class << self
    def run
      calibration_values = []
      File.foreach(File.join(__dir__, "input.dat")).each_entry do |line|
        scrubbed = line.tr("^0-9", "").split("")
        calibration_values << scrubbed.first
        calibration_values << scrubbed.last
      end

      calibration_values.each_slice(2).to_a.map { |x| x.join("").to_i }.sum
    end
  end
end

puts DayOne.run
