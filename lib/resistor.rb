require "resistor/version"
require "resistor/options"
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
    #   r1 = Resistor.new(20)
    #   r2 = Resistor.new(['yellow', 'purple', 'red', 'gold'])
    def new(arg, options = {})
      Resistor::BasicResistor.new(arg, options)
    end
  end
end
