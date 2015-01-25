module Resistor
  class CombinedResistor

    attr_reader :ohm

    # Initializes a new CombinedResistor object.
    #
    # @see BasicResistor#+
    # @see BasicResistor#/
    # @param ohm [Float] resistance value
    # @return [Resistor::CombinedResistor]
    def initialize(ohm)
      @ohm = ohm.to_f
    end

    # Calculates a series combined resistance value.
    #
    # @param other [Resistor::BasicResistor, Resistor::CombinedResistor]
    # @return [Resistor::CombinedResistor]
    def +(other)
      Resistor::CombinedResistor.new(@ohm + other.ohm)
    end

    # Calculates a parallel combined resistance value.
    #
    # @param other [Resistor::BasicResistor, Resistor::CombinedResistor]
    # @return [Resistor::CombinedResistor]
    def /(other)
      Resistor::CombinedResistor.new(1 / (1 / @ohm + 1 / other.ohm))
    end
  end
end
