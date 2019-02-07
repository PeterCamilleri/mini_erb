
require_relative "../lib/mini_erb"

x     = 42
$env  = binding

str = "ABCD<%= (1..9).to_a.join %>EFGH"
puts MiniErb.new(str).result($env)

str = "<% if x==42 %>Life, the Universe and Everything<% else %>Some stuff<% end %>"
puts MiniErb.new(str).result($env)

str = "<% 5.times { |i| %> <%= i+1 %> sheep <% } %>"
puts MiniErb.new(str).result($env)


