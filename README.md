# Gruff Graphs

[![Build Status](https://travis-ci.org/topfunky/gruff.png?branch=master)](https://travis-ci.org/topfunky/gruff)
[![Gem Version](https://badge.fury.io/rb/gruff.png)](http://badge.fury.io/rb/gruff)

A library for making beautiful graphs.

## Installation

Add this line to your application's Gemfile:

    gem 'gruff', github: 'tryceattack/gruff'

And then execute:

    $ bundle install


## Usage

```Ruby
In a script,

#!/usr/bin/env ruby
require 'gruff'
g = Gruff::CustomPie.new('./flowers.png') #Use your own image, 400x300 at least would be nice
hash = {
      'fill' => 'blue',
      'font_family' => 'Helvetica',
      'pointsize' => 64,
      'font_weight' => 700
    }

g.insert_text(100, 100, 'hi',hash)
g.set_pie_geometry(200,200,30)
g.insert_pie_data("ndaf me1", 3,0)
g.insert_pie_data("nama sdfe3", 4,1)
g.insert_pie_data("nggf esdaf5", 1,2)
g.insert_pie_data("damasdfe8", 3,2)
g.insert_pie_data("namesadf9", 0,0)
g.insert_pie_data("nadsfame10", 0,0)
g.insert_pie_data("aasafe11", 0,0)
g.insert_pie_data("p443", 0,2)
g.insert_pie_data("nafdsr", 0,2)
g.insert_pie_data("qq", 0,1)
g.insert_pie_data("dr tee11", 0,3)
g.insert_pie_data("234 sdafe11", 0,3)
g.write #writes to graph.png in current directory

```

## Examples

You can find many examples in the [test](https://github.com/topfunky/gruff/tree/master/test)
directory along with their resulting charts in the
[output](https://github.com/topfunky/gruff/tree/master/test/output) directory.

You can find older examples here:  http://nubyonrails.com/pages/gruff


#Documentation
	Pretty small library in custom_pie.rb, so just look at the code

## Contributing

### Source

