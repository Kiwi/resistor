module Resistor
  class Options

    @defaults = {
      :band_number => 4,
      :tolerance   => 5.0
    }

    attr_reader :band_number, :tolerance

    class << self
       # The default option values.
       # `@defaults` is a hash of the default options.
       #
       # @yield You can set the options in a block too.
       # @return [Hash]
       # @example Sets the options in a block.
       #   Resistor::Options.defaults do |d|
       #     d[:tolerance] = 0.5
       #     d[:band_number] = 5
       #   end
      def defaults(&block)
        yield @defaults if block_given?
        @defaults
      end

      # Sets a combination of options that is usually used.
      #
      # @param num [Integer] The number of the color bands
      def set_band_number(num)
        case num
        when 4
          @defaults[:band_number] = 4
          @defaults[:tolerance] = 5.0
        when 5
          @defaults[:band_number] = 5
          @defaults[:tolerance] = 1.0
        end
      end
    end

    # Initializes a new BasicResistor object.
    # The default option values is stored in the instance variables.
    #
    # @return [Resistor::BasicResistor]
    def initialize
      self.class.defaults.each do |key, val|
        instance_variable_set("@#{key}", val)
      end
    end
  end
end
