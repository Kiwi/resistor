module Resistor
  class Options

    @defaults = {
      :band_number => 4,
      :tolerance   => 5.0
    }

    attr_reader :band_number, :tolerance

    def self.defaults
      @defaults
    end

    def self.set_4band
      @defaults[:band_number] = 4
      @defaults[:tolerance] = 5.0
    end

    def self.set_5band
      @defaults[:band_number] = 5
      @defaults[:tolerance] = 1.0
    end

    def initialize
      self.class.defaults.each do |key, val|
        instance_variable_set("@#{key}", val)
      end
    end
  end
end
