# Resistor
Resistor is a gem for the resistor unit.  

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
`Resistor::ColorCode.encode` **Converts a resistance value to a color code.**  
`Resistor::ColorCode.decode` **Converts a color code to a resistance value.**  

```ruby
require 'resistor'

Resistor::ColorCode.encode(4700)
# => [:yellow, :purple, :red, :gold]
Resistor::ColorCode.decode([:yellow, :purple, :red, :gold])
# => 4700.0
```

### Combined Resistor Calculator
`Resistor::BasicReisistor#+` **Calculates a series combined resistance value.**  
`Resistor::BasicReisistor#/` **Calculates a parallel combined resistance value.**  

`Resistor.new` is an alias for `Resistor::BasicResistor.new`

```ruby
require 'resistor'

r1 = Resistor.new(ohm: 20)
r2 = Resistor.new(ohm: 30)
r3 = Resistor.new(ohm: 4)
r4 = Resistor.new(ohm: 8)

#    --[r1]--          --[r4]--
# --|        |--[r3]--|        |--
#    --[r2]--          --[r4]--
r5 = (r1 / r2) + r3 + (r4 / r4)
r5.ohm # => 20.0
```

### E Series
`Resistor::BasicReisistor#e12?` **Whether or not the resistance value is the E12 series.**  
`Resistor::BasicReisistor#e24?` **Whether or not the resistance value is the E24 series.**  

```ruby
require 'resistor'

r1 = Resistor.new(ohm: 4700)
r2 = Resistor.new(ohm: 62)

r1.e12? # => true
r1.e24? # => true
r2.e12? # => false
r2.e24? # => true
```
