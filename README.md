# Resistor

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

```ruby
require 'resistor'

# Resistor Color Code Calculation
Resistor::ColorCode.encode(4700) # => [:yellow, :purple, :red, :gold]
Resistor::ColorCode.decode([:yellow, :purple, :red, :gold]) # => 4700.0

# Combined Resistance Calculation
#    --[r1]--          --[r4]--
# --|        |--[r3]--|        |--
#    --[r2]--          --[r4]--

r1 = Resistor.new(ohm: 20)
r2 = Resistor.new(ohm: 30)
r3 = Resistor.new(ohm: 4)
r4 = Resistor.new(ohm: 8)

r5 = (r1 / r2) + r3 + (r4 / r4)
r5.ohm # => 20.0

# E Series Checker
r1 = Resistor.new(ohm: 4700)
r2 = Resistor.new(ohm: 62)

r1.e12? # => true
r1.e24? # => true
r2.e12? # => false
r2.e24? # => true
```
