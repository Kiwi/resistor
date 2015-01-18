module Resistor
  class CombinedResistor

    attr_reader :ohm

    def initialize(ohm)
      @ohm = ohm.to_f
    end

    def +(other)
      Resistor::CombinedResistor.new(@ohm + other.ohm)
    end

    def /(other)
      Resistor::CombinedResistor.new(1 / (1 / @ohm + 1 / other.ohm))
    end
  end
end
