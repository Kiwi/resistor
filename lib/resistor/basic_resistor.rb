module Resistor
  class BasicResistor

    attr_reader :ohm, :code, :error_range

    # Initializes a new BasicResistor object.
    # Both the ohm and code parameter are optional,
    # but at least one of them must be supplied.
    #
    # @option options [Integer, Float] :ohm(nil) resistance value
    # @option options [Array<Symbol>, Array<String>] :code(nil) color code
    # @option options [Integer, Float] :error_range(5.0)
    # @raise [ArgumentError] The ohm or code parameter must be supplied.
    #   Error raised if neither parameter is supplied.
    # @return [Resistor::BasicResistor]
    # def initialize(ohm:nil, code:nil, error_range: 5.0)
    def initialize(options = {})
      options[:error_range] ||= 5.0
      opt = {:error_range => options[:error_range]}
      if options[:ohm]
        @ohm = options[:ohm].to_f
        @code = Resistor::ColorCode.encode(@ohm, opt)
        @error_range = options[:error_range]
      elsif options[:code]
        raise ArgumentError unless options[:code].is_a? Array
        @code = options[:code].map(&:to_sym)
        @ohm = Resistor::ColorCode.decode(@code)
        @error_range = Resistor::ColorCode::ERROR_RANGE[@code[3].to_sym]
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
    # and the error range is also changed.
    #
    # @param code [Array<Symbol>, Array<String>] color code
    def code=(code)
      @code = code.map(&:to_sym)
      @ohm = Resistor::ColorCode.decode(@code)
      @error_range = Resistor::ColorCode::ERROR_RANGE[@code[3].to_sym]
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
      num0 = Resistor::ColorCode::NUM[@code[0]]
      num1 = Resistor::ColorCode::NUM[@code[1]]
      Resistor::ColorCode::E12_SERIES.each do |key, val|
        if num0 == key
          return true if val.any? { |e| e == num1 }
        end
      end
      return false
    end

    # @return [Boolean] Whether or not the resistance value is the E24 series.
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
