require 'rack'
require 'logger'
module Rack
  class Hanoi
    def initialize(app)
      @app = app
    end
    
    def call(env)
      return (if md = env["PATH_INFO"].match(%r|^/hanoi/(\d+)|)
                height = md[1].to_i
                HanoiApp.new(true, height).call(env)
              else
                @app.call(env)
              end)
    end
  end
  
  class HanoiApp
    def initialize(root, height, from=:A, to=:C, via=:B)
      @root, @height, @from, @to, @via = root, height, from, to, via
    end
    
    def call(env)
      env["rack.hanoi"] ||= ""
      logger = env["rack.logger"] || ::Logger.new(STDERR)
      if @height < 1
        return Rack::Response.new do |res|
          res["Content-Type"] = "text/plain"
          res.body << with_lines(env["rack.hanoi"])
        end.finish
      else
        HanoiApp.new(false, @height - 1, @from, @via, @to).call(env)
        logger.info "Disc Moved #{@from} to #{@to}"
        env["rack.hanoi"] << "Disc Moved #{@from} to #{@to}\n"
        HanoiApp.new(false, @height - 1, @via, @to, @from).call(env)
      end
    end
    
    private
    def with_lines(body)
      lines = body.strip.lines
      digits = (Math.log(lines.to_a.size - 1) / Math.log(10)).floor + 1 rescue 1
      lines.map.with_index{|ln, i| "%0#{digits}d: %s" % [i, ln]}.join
    end
  end
end
