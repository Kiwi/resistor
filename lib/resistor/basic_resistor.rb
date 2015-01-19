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
        @code = code.map(&:to_sym)
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
      @code = code.map(&:to_sym)
      @ohm = Resistor::ColorCode.decode(@code)
      @error_range = Resistor::ColorCode::ERROR_RANGE[@code[3].to_sym]
    end

    def +(other)
      Resistor::CombinedResistor.new(@ohm + other.ohm)
    end

    def /(other)
      Resistor::CombinedResistor.new(1 / (1 / @ohm + 1 / other.ohm))
    end

    def e12?
      num0 = Resistor::ColorCode::NUM[@code[0]]
      num1 = Resistor::ColorCode::NUM[@code[1]]
      Resistor::ColorCode::E12_SERIES.each do |key, val|
        if num0 == key
          return true if val.any? { |e| e == num1 }
        end
      end
      return false
    end

    def e24?
      num0 = Resistor::ColorCode::NUM[@code[0]]
      num1 = Resistor::ColorCode::NUM[@code[1]]
      Resistor::ColorCode::E24_SERIES.each do |key, val|
        if num0 == key
          return true if val.any? { |e| e == num1 }
        end
      end
      return false
    end
  end
end
