require 'helper'

class TestPebblesRackHanoi < Test::Unit::TestCase
  should "respond_to #call" do
    @app = Rack::Hanoi.new(lambda {})
    assert @app.respond_to? :call
  end
end
