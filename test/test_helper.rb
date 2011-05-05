require 'test/unit'
require 'rubygems'
require 'rr'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end
