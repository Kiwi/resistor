module Resistor
  class BasicResistor

    attr_reader :ohm, :code, :error_range

    def initialize(ohm:nil, code:nil, error_range: 5.0)
      opt = {error_range: error_range}
      if ohm
        @ohm = ohm.to_f
        @code = Resistor::ColorCode.encode(@ohm, opt)
        @error_range = error_range
      elsif code
        raise ArgumentError unless code.is_a? Array
        @code = code
        @ohm = Resistor::ColorCode.decode(@code)
        @error_range = Resistor::ColorCode::ERROR_RANGE[@code[3].to_sym]
      else
        raise ArgumentError
      end
    end

    def ohm=(ohm)
      @ohm = ohm.to_f
      @code = Resistor::ColorCode.encode(@ohm)
    end

    def code=(code)
      @code = code
      @ohm = Resistor::ColorCode.decode(@code)
      @error_range = Resistor::ColorCode::ERROR_RANGE[@code[3].to_sym]
    end

    def +(other)
      Resistor::CombinedResistor.new(@ohm + other.ohm)
    end

    def /(other)
      Resistor::CombinedResistor.new(1 / (1 / @ohm + 1 / other.ohm))
    end
  end
end
