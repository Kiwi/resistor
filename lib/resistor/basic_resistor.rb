module Resistor
  class BasicResistor

    attr_reader :ohm, :code, :tolerance

    # Initializes a new BasicResistor object.
    # Both the ohm and code parameter are optional,
    # but at least one of them must be supplied.
    #
    # @overload initialize(arg, options = {})
    #   @param arg [Integer, Float] A resistance value.
    # @overload initialize(arg, options = {})
    #   @param arg [Array<Symbol>, Array<String>] A color code.
    # @option options [Integer, Float] :tolerance(5.0)
    # @raise [ArgumentError] The ohm or code parameter must be supplied.
    #   Error raised if neither parameter is supplied.
    # @return [Resistor::BasicResistor]
    def initialize(arg, options = {})
      default = Resistor::Options.new
      options[:tolerance] ||= default.tolerance
      options[:band_number] ||= default.band_number

      case arg
      when Integer, Float
        @ohm = arg.to_f
        @code = Resistor::ColorCode.encode(@ohm, options)
        @tolerance = options[:tolerance]
      when Array
        @code = arg.map(&:to_sym)
        @ohm = Resistor::ColorCode.decode(@code, options)
        @tolerance = Resistor::ColorCode::TOLERANCE[@code[-1].to_sym]
      else
        raise ArgumentError
      end
    end

    # Set a resistance value.
    # When the resistance value is changed, the color code is also changed.
    #
    # @param ohm [Integer, Float] resistance value
    def ohm=(ohm)
      @ohm = ohm.to_f
      @code = Resistor::ColorCode.encode(@ohm)
    end

    # Set a color code.
    # When the color code is changed, the resistance value is also changed,
    # and the tolerance is also changed.
    #
    # @param code [Array<Symbol>, Array<String>] color code
    def code=(code)
      @code = code.map(&:to_sym)
      @ohm = Resistor::ColorCode.decode(@code)
      @tolerance = Resistor::ColorCode::TOLERANCE[@code[3].to_sym]
    end

    # Calculates a series combined resistance value.
    #
    # @param other [Resistor::BasicResistor, Resistor::CombinedResistor]
    # @return [Resistor::CombinedResistor]
    def +(other)
      Resistor::CombinedResistor.new(@ohm + other.ohm)
    end
    alias_method :-, :+

    # Calculates a parallel combined resistance value.
    #
    # @param other [Resistor::BasicResistor, Resistor::CombinedResistor]
    # @return [Resistor::CombinedResistor]
    def /(other)
      Resistor::CombinedResistor.new(1 / (1 / @ohm + 1 / other.ohm))
    end
    alias_method :|, :/

    # @return [Boolean] Whether or not the resistance value is the E12 series.
    def e12?
      num0 = Resistor::ColorCode::DIGIT[@code[0]]
      num1 = Resistor::ColorCode::DIGIT[@code[1]]
      Resistor::ColorCode::E12_SERIES.each do |key, val|
        if num0 == key
          return true if val.any? { |e| e == num1 }
        end
      end
      return false
    end

    # @return [Boolean] Whether or not the resistance value is the E24 series.
    def e24?
      num0 = Resistor::ColorCode::DIGIT[@code[0]]
      num1 = Resistor::ColorCode::DIGIT[@code[1]]
      Resistor::ColorCode::E24_SERIES.each do |key, val|
        if num0 == key
          return true if val.any? { |e| e == num1 }
        end
      end
      return false
    end
  end
end
