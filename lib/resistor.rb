require "resistor/version"
require "resistor/color_code"
require "resistor/basic_resistor"
require "resistor/combined_resistor"

module Resistor

  class << self
    def new(opt = {})
      Resistor::BasicResistor.new(opt)
    end
  end
end
