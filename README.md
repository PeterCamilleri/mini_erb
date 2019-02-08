# MiniErb

The mini_erb gem is another spin off from the mysh project. In testing the
handlebars embedded Ruby system used there, it was observed that the test
code was faster than both the native erb and the faster erubi.

The mini_erb gem returns to the syntax of erb but is based on the same
algorithm of the mysh handlebars.

In performance it is still faster. This is laid out in this
[report](https://github.com/PeterCamilleri/mini_erb/blob/master/docs/embbed_ruby_study.pdf)
.

### Embedding Ruby into text or html

The use of erb to embed ruby code into text or html is widely covered, so only
a brief summary of this topic is presented here.

1. **Embedding ruby computed values into the text.**

The following embeds the results of the execution of the ruby into the results.

```ruby
env  = binding

str = "ABCD<%= (1..9).to_a.join %>EFGH"
puts MiniErb.new(str).result(env)
```
produces

    ABCD123456789EFGH

2. **Using ruby to control the generated text.**

You can also use ruby to control what text or html is included in the output.
This allows the ruby code to select which text/html is included and even to
repeat sections.

```ruby
x     = 42
env  = binding

str = "<% if x==42 %>Life, the Universe and Everything<% else %>Some stuff<% end %>"
puts MiniErb.new(str).result(env)
```
produces

    Life, the Universe and Everything

and

```ruby
env  = binding

str = "<% 5.times { |i| %> <%= i+1 %> sheep <% } %>"
puts MiniErb.new(str).result(env)
```
produces

     1 sheep  2 sheep  3 sheep  4 sheep  5 sheep

3. **Control of debug code.**

Sometimes, there is a need to add code for debug or testing purposes. In
production, we do not want this code interfering with normal operation but we
may not wish to simply delete it. The following example shows some "debug"
code.

```ruby
env  = binding

str = "Now is the hour of our discontent! <%= "Answer=42" %>"
puts MiniErb.new(str).result(env)
```
produces

    Now is the hour of our discontent! Answer=42

In production use, we can turn off that code with:
```ruby
env  = binding

str = "Now is the hour of our discontent! <%#= "Answer=42" %>"
puts MiniErb.new(str).result(env)
```
and now we get this clean output

    Now is the hour of our discontent!

4. **Removal of unwanted new-lines**

Sometimes in formatting the embedded ruby code, it is desired to add extra
new-lines to make the code easier to read and understand. These extra lines
may not be desirable in the output. These can be controlled as follows:

```ruby
env  = binding

str = <<-end_of_string
ABCD<%= (1..9).to_a.join -%>
EFGH
end_of_string

puts MiniErb.new(str).result(env)
```
produces

    ABCD123456789EFGH

Note how the output does not contain the spurious new line between the
"9" and "E" characters.

### Differences from traditional erb.

The mini_erb gem supports a subset of the functionality of erb.
The following lays out the differences:

* The suppression of new lines with a tag ending in -&#37;> is active by default.
* The use of code lines starting with a % sign is not supported. Instead use
<%  ... %> embedded code blocks.
* In erb, <%% maps to <%. In mini_erb use <\&#37; instead. The same goes for
%%> which is replaced by \&#37;>.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mini_erb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mini_erb

## Usage

WIP

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

OR...

* Make a suggestion by raising an
 [issue](https://github.com/PeterCamilleri/mini_erb/issues)
. All ideas and comments are welcome.

## License

The gem is available as open source under the terms of the
[MIT License](./LICENSE.txt).

## Code of Conduct

Everyone interacting in the mini_erb project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](./CODE_OF_CONDUCT.md).
