require "resistor/version"
require "resistor/color_code"
require "resistor/basic_resistor"
require "resistor/combined_resistor"

module Resistor

  class << self
    # Alias for Resistor::BasicResistor.new
    #
    # @see Resistor::BasicResistor
    # @return [Resistor::BasicResistor]
    # @example Create a Resistor::BasicResistor object.
    #   r1 = Resistor.new(ohm: 20)
    #   r2 = Resistor.new(code: ['yellow', 'purple', 'red', 'gold'])
    def new(options = {})
      Resistor::BasicResistor.new(options)
    end
  end
end
