
require_relative "../lib/mini_erb"

x     = 42
env  = binding

puts "The mini_erb examples in the readme file, confirmed here.", ""

str = "ABCD<%= (1..9).to_a.join %>EFGH"
puts str, MiniErb.new(str).result(env), ""

str = "<% if x==42 %>Life, the Universe and Everything<% else %>Some stuff<% end %>"
puts str, MiniErb.new(str).result(env), ""

str = "<% 5.times { |i| %> <%= i+1 %> sheep <% } %>"
puts str, MiniErb.new(str).result(env), ""

str = "Now is the hour of our discontent! <%= \"Answer=#{x}\" %>"
puts str, MiniErb.new(str).result(env), ""

str = "Now is the hour of our discontent! <%#= \"Answer=#{x}\" %>"
puts str, MiniErb.new(str).result(env), ""

str = <<-end_of_string
ABCD<%= (1..9).to_a.join -%>
EFGH
end_of_string
puts str, MiniErb.new(str).result(env), ""
