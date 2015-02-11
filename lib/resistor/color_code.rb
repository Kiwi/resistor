module Resistor
  module ColorCode

    DIGIT = {
      :black  => 0,
      :brown  => 1,
      :red    => 2,
      :orange => 3,
      :yellow => 4,
      :green  => 5,
      :blue   => 6,
      :purple => 7,
      :gray   => 8,
      :white  => 9
    }.freeze

    MULTIPLIER = {
      :black  => 0,
      :brown  => 1,
      :red    => 2,
      :orange => 3,
      :yellow => 4,
      :green  => 5,
      :blue   => 6,
      :gold   => -1,
      :silver => -2
    }.freeze

    TOLERANCE = {
      :brown  => 1.0,
      :red    => 2.0,
      :orange => 0.05,
      :green  => 0.5,
      :blue   => 0.25,
      :purple => 0.1,
      :gold   => 5.0,
      :silver => 10.0
    }.freeze

    E12_SERIES = {
      1 => [0, 2, 5, 8],
      2 => [2, 7],
      3 => [3, 9],
      4 => [7],
      5 => [6],
      6 => [8],
      8 => [2],
    }.freeze

    E24_SERIES = {
      1 => [0, 1, 2, 3, 5, 6, 8],
      2 => [0, 2, 4, 7],
      3 => [0, 3, 6, 9],
      4 => [3, 7],
      5 => [1, 6],
      6 => [2, 8],
      7 => [5],
      8 => [2],
      9 => [1]
    }.freeze


    # Converts a resistance value to a color code.
    # The value must be between 0.1 and 99_000_000.
    #
    # @param ohm [Integer, Float] resistance value
    # @option options [Integer, Float] :tolerance(5.0)
    # @raise [ArgumentError] Error raised
    #   when the supplied resistance value is less than 0.1.
    # @return [Array<Symbol>] color code
    def self.encode(ohm, options = {:tolerance => 5.0})
      return [DIGIT.key(0)] if ohm == 0
      raise ArgumentError if ohm < 0.1

      if ohm < 1
        ohm_str = (ohm*100).to_s.split('')
        [DIGIT.key(ohm_str[0].to_i), DIGIT.key(ohm_str[1].to_i),
         MULTIPLIER.key(-2), TOLERANCE.key(options[:tolerance])]

      elsif ohm < 10
        ohm_str = (ohm*10).to_s.split('')
        [DIGIT.key(ohm_str[0].to_i), DIGIT.key(ohm_str[1].to_i),
         MULTIPLIER.key(-1), TOLERANCE.key(options[:tolerance])]

      else
        ohm_str = ohm.to_i.to_s.split('')
        [DIGIT.key(ohm_str[0].to_i), DIGIT.key(ohm_str[1].to_i),
         MULTIPLIER.key(ohm_str.size - 2), TOLERANCE.key(options[:tolerance])]
      end
    end

    # Converts a color code to a resistance value.
    #
    # @param code [Array<Symbol>, Array<String>] color code
    # @raise [ArgumentError] Error raised
    #   when the supplied color code is not an array,
    #   or when the color of the first band is black.
    # @return [Float] resistance value
    def self.decode(code)
      raise ArgumentError unless code.is_a? Array
      code = code.map(&:to_sym)
      return 0.0 if code == [:black]
      raise ArgumentError if code[0] == :black

      ohm = (DIGIT[code[0]]*10 + DIGIT[code[1]]) * 10**MULTIPLIER[code[2]]
      return ohm.to_f
    end
  end
end
