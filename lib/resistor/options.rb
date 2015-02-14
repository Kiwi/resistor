module Resistor
  class Options

    @defaults = {
      :band_number => 4,
      :tolerance   => 5.0
    }

    attr_reader :band_number, :tolerance

    class << self
      def defaults(&block)
        yield @defaults if block_given?
        @defaults
      end

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

    def initialize
      self.class.defaults.each do |key, val|
        instance_variable_set("@#{key}", val)
      end
    end
  end
end
