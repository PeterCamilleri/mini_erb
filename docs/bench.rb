require "benchmark/ips"
require 'erb'
require 'erubi'
require 'pp'

require_relative "../lib/mini_erb"

x     = 42
$env  = binding

def use_erb(string, evaluator)
  ERB.new(string).result(evaluator)
end

def use_erubi(string, evaluator)
  evaluator.eval(Erubi::Engine.new(string).src)
end

def use_mini_erb(string, evaluator)
  MiniErb.new(string).result(evaluator)
end

work_list = [1, 10, 100, 1000, 10000]

Item = Struct.new(:data, :work)

items = {"erb"      => Item.new([], Proc.new { use_erb($esrc, $env) }),
         "erubi"    => Item.new([], Proc.new { use_erubi($esrc, $env)  }),
         "mini_erb" => Item.new([], Proc.new { use_mini_erb($esrc, $env) })
        }

work_list.each do |lines|

  puts "Lines = #{lines}",""

  $esrc = "The answer to life, the universe and everything is <%= x %>.\n" * lines

  # Use an arg of 't' to test for correct output.
  if ARGV[0] == 't'
    puts use_erb($esrc, $env)
    puts use_erubi($esrc, $env)
    puts use_mini_erb($esrc, $env)

    exit
  end

  report = Benchmark.ips do |x|

    items.each do |name, item|
      x.report(name, &item.work)
    end

    x.compare!
  end

  fastest = -1.0

  report.data.each do |test_result|
    fastest = test_result[:ips] if test_result[:ips] > fastest
  end

  report.data.each do |test_result|
    name = test_result[:name]
    ips  = test_result[:ips]
    items[name].data << fastest/ips
  end

end

items.each do |name, item|
  puts name, item.data, ""
end
