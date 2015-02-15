# Resistor
[![Gem Version](https://badge.fury.io/rb/resistor.svg)](http://badge.fury.io/rb/resistor)  
Resistor is a gem for the resistor unit.  
For more details, please see [http://qiita.com/seinosuke/items/d527b0e591d6d69c7471](http://qiita.com/seinosuke/items/d527b0e591d6d69c7471).

## Installation

Add this line to your application's Gemfile:  

```ruby
gem 'resistor'
```

And then execute:  

    $ bundle install

Or install it yourself as:  

    $ gem install resistor

## Usage

###Resistor Color Code Converter
You can calculate a resistance value from a color code. The contrary is possible.  
`Resistor::ColorCode.encode` Converts a resistance value to a color code.  
`Resistor::ColorCode.decode` Converts a color code to a resistance value.  

```ruby
require 'resistor'

Resistor::ColorCode.encode(4700)
# => [:yellow, :purple, :red, :gold]
Resistor::ColorCode.decode([:yellow, :purple, :red, :gold])
# => 4700.0
```

### Combined Resistor Calculator
You can calculate a combined resistance value.  
`Resistor::BasicReisistor#+` Calculates a series combined resistance value.  
`Resistor::BasicReisistor#/` Calculates a parallel combined resistance value.  

`Resistor.new` is an alias for `Resistor::BasicResistor.new`  

```ruby
require 'resistor'

r1 = Resistor.new(20)
r2 = Resistor.new(30)
r3 = Resistor.new(4)
r4 = Resistor.new(8)

#    --[r1]--          --[r4]--
# --|        |--[r3]--|        |--
#    --[r2]--          --[r4]--
r5 = (r1 / r2) + r3 + (r4 / r4)
r5.ohm # => 20.0
```

### 5-Band Color Code
Selects a number of color bands. By dafault, the number is 4.  
`Resistor::Options.set_band_number` Sets a combination of options that is usually used.  

```ruby
require 'resistor'

Resistor::Options.set_band_number 5
Resistor.new(976)
# => #<Resistor::BasicResistor:0x0000000295fb58 @ohm=976.0, @code=[:white, :purple, :blue, :black, :brown], @tolerance=1.0>
Resistor::ColorCode.encode(100)
# => [:brown, :black, :black, :black, :brown]

Resistor::Options.set_band_number 4
Resistor.new(4700)
# => #<Resistor::BasicResistor:0x0000000295ee10 @ohm=4700.0, @code=[:yellow, :purple, :red, :gold], @tolerance=5.0>
Resistor::ColorCode.encode(100)
# => [:brown, :black, :brown, :gold]
```


### E Series
`Resistor::BasicReisistor#e12?` Whether or not the resistance value is the E12 series.  
`Resistor::BasicReisistor#e24?` Whether or not the resistance value is the E24 series.  
`Resistor::BasicReisistor#e48?` Whether or not the resistance value is the E48 series.  
`Resistor::BasicReisistor#e96?` Whether or not the resistance value is the E96 series.  
`#48?` and `#96?` always return false if the number of bands is 4.  

```ruby
require 'resistor'

r1 = Resistor.new(4700)
r2 = Resistor.new(62)

r1.e12? # => true
r1.e24? # => true
r2.e12? # => false
r2.e24? # => true

Resistor::Options.set_band_number 5

r3 = Resistor.new(105)
r4 = Resistor.new(4.99)

r3.e48? # => true
r3.e96? # => true
r4.e48? # => false
r4.e96? # => true
```
