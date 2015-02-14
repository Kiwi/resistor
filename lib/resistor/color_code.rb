module Resistor
  module ColorCode

    # [4-Band-Code] The 1st and 2nd digit of a resistance value
    # [5-Band-Code] The 1st, 2nd and 3rd digit of a resistance value
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

    # [4-Band-Code] The 3rd color band indicates the multiplier.
    # [5-Band-Code] The 4th color band indicates the multiplier.
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

    # [4-Band-Code] The 4th color band indicates the tolerance.
    # [5-Band-Code] The 5th color band indicates the tolerance.
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

    E48_SERIES = [
      100, 105, 110, 115, 121, 127, 133, 140, 147, 154, 162, 169, 178, 187, 196, 205,
      215, 226, 237, 249, 261, 274, 287, 301, 316, 332, 348, 365, 383, 402, 422, 442,
      464, 487, 511, 536, 562, 590, 619, 649, 681, 715, 750, 787, 825, 866, 909, 953
    ].freeze

    E96_SERIES = [
      100, 102, 105, 107, 110, 113, 115, 118, 121, 124, 127, 130, 133, 137, 140, 143,
      147, 150, 154, 158, 162, 165, 169, 174, 178, 182, 187, 191, 196, 200, 205, 210,
      215, 221, 226, 232, 237, 243, 249, 255, 261, 267, 274, 280, 287, 294, 301, 309,
      316, 324, 332, 340, 348, 357, 365, 374, 383, 392, 402, 412, 422, 432, 442, 453,
      464, 475, 487, 499, 511, 523, 536, 549, 562, 576, 590, 604, 619, 634, 649, 665,
      681, 698, 715, 732, 750, 768, 787, 806, 825, 845, 866, 887, 909, 931, 953, 976
    ].freeze

    module_function

    # Converts a resistance value to a color code.
    # The value must be between 0.1 and 99_000_000.
    #
    # @param ohm [Integer, Float] resistance value
    # @option options [Integer, Float] :tolerance(5.0)
    # @option options [Integer] :band_number(4)
    # @raise [ArgumentError] Error raised
    #   when the supplied resistance value is less than 0.1.
    # @return [Array<Symbol>] color code
    def encode(ohm, options = {})
      return [DIGIT.key(0)] if ohm == 0
      raise ArgumentError if ohm < 0.1

      default = Resistor::Options.new
      options[:tolerance] ||= default.tolerance
      options[:band_number] ||= default.band_number

      case options[:band_number]
      when 4 then four_band_encode(ohm, options)
      when 5 then five_band_encode(ohm, options)
      else raise ArgumentError
      end
    end

    # This method is used by the `Colorcode.encode` method
    # when `options[:band_number]` is 4.
    def four_band_encode(ohm, options = {})
      if ohm < 1
        ohm_str = (ohm*100).to_s.split('')
        [DIGIT.key(ohm_str[0].to_i),
         DIGIT.key(ohm_str[1].to_i),
         MULTIPLIER.key(-2),
         TOLERANCE.key(options[:tolerance])]

      elsif ohm < 10
        ohm_str = (ohm*10).to_s.split('')
        [DIGIT.key(ohm_str[0].to_i),
         DIGIT.key(ohm_str[1].to_i),
         MULTIPLIER.key(-1),
         TOLERANCE.key(options[:tolerance])]

      else
        ohm_str = ohm.to_i.to_s.split('')
        [DIGIT.key(ohm_str[0].to_i),
         DIGIT.key(ohm_str[1].to_i),
         MULTIPLIER.key(ohm_str.size - 2),
         TOLERANCE.key(options[:tolerance])]
      end
    end

    # This method is used by the `Colorcode.encode` method
    # when `options[:band_number]` is 5.
    def five_band_encode(ohm, options = {})
      if ohm < 10
        ohm_str = (ohm*100).to_s.split('')
        [DIGIT.key(ohm_str[0].to_i),
         DIGIT.key(ohm_str[1].to_i),
         DIGIT.key(ohm_str[2].to_i),
         MULTIPLIER.key(-2),
         TOLERANCE.key(options[:tolerance])]

      elsif ohm < 100
        ohm_str = (ohm*10).to_s.split('')
        [DIGIT.key(ohm_str[0].to_i), 
         DIGIT.key(ohm_str[1].to_i),
         DIGIT.key(ohm_str[2].to_i),
         MULTIPLIER.key(-1),
         TOLERANCE.key(options[:tolerance])]

      else
        ohm_str = ohm.to_i.to_s.split('')
        [DIGIT.key(ohm_str[0].to_i), 
         DIGIT.key(ohm_str[1].to_i),
         DIGIT.key(ohm_str[2].to_i),
         MULTIPLIER.key(ohm_str.size - 3),
         TOLERANCE.key(options[:tolerance])]
      end
    end

    # Converts a color code to a resistance value.
    #
    # @param code [Array<Symbol>, Array<String>] color code
    # @option options [Integer] :band_number(4)
    # @raise [ArgumentError] Error raised
    #   when the supplied color code is not an array,
    #   or when the color of the first band is black.
    # @return [Float] resistance value
    def decode(code, options = {})
      raise ArgumentError unless code.is_a? Array
      code = code.map(&:to_sym)
      return 0.0 if code == [:black]
      raise ArgumentError if code[0] == :black

      default = Resistor::Options.new
      options[:band_number] ||= default.band_number

      case options[:band_number]
      when 4 then four_band_decode(code)
      when 5 then five_band_decode(code)
      else raise ArgumentError
      end
    end

    # This method is used by the `Colorcode.decode` method
    # when `options[:band_number]` is 4.
    def four_band_decode(code)
      (DIGIT[code[0]]*10 + DIGIT[code[1]]) *
      10**MULTIPLIER[code[2]]
      .to_f
    end

    # This method is used by the `Colorcode.decode` method
    # when `options[:band_number]` is 5.
    def five_band_decode(code)
      (DIGIT[code[0]]*100 + DIGIT[code[1]]*10 + DIGIT[code[2]]) *
      10**MULTIPLIER[code[3]]
      .to_f
    end
  end
end
