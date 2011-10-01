$LOAD_PATH << '../lib'
require 'pebbles-rack-hanoi'

use Rack::Hanoi
run lambda {|e|
  [200, {"Content-Type" => "text/plain"}, ["OK"]]
}
