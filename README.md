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
env = binding

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
x   = 42
env = binding

str = "<% if x==42 %>Life, the Universe and Everything<% else %>Some stuff<% end %>"
puts MiniErb.new(str).result(env)
```
produces

    Life, the Universe and Everything

and

```ruby
env = binding

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
env = binding

str = "Now is the hour of our discontent! <%= "Answer=42" %>"
puts MiniErb.new(str).result(env)
```
produces

    Now is the hour of our discontent! Answer=42

In production use, we can turn off that code with:
```ruby
env = binding

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
env = binding

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

The use of the mini_erb gem comes in two distinct phases.

1. Creating a mini_erb object. This object contains the source input transpiled
into ruby code.
2. Executing the transpiled code in an execution environment.

### Phase 1

Creating a mini_erb object is done simply with the standard new method. The
corresponding initialize method is:

```ruby
def initialize(string, safe_level=nil, _=nil, eoutvar='_erbout')
  @safe_level, @eoutvar = safe_level, eoutvar
  @filename, @lineno = "(mini_erb)", 0
  @src = compile(string)
end
```

where:

* *string* is a string containing the source text embedded with ruby code.
* *safe_level* is an optional parameter controlling the level of distrust of the
embedded ruby code. While outside the purview of this file, the following gives
a nice summary of the available options:

safe_level | constraints
-----------|--------------
0          | No checking of the use of externally supplied (tainted) data is performed. This is the default.
≥ 1        | Ruby disallows the use of tainted data by potentially dangerous operations.
≥ 2        | Ruby prohibits the loading of program files from globally writable locations.
≥ 3        | All newly created objects are considered tainted and untrusted.
≥ 4        | Ruby effectively partitions the running program in two. Nontrusted objects may not be modified.

(Source: Programming Ruby by Dave Thomas with Chad Fowler and Andy Hunt)

* *_* is an optional and unused parameter retained only for erb compatibility.
* *eoutvar* is an optional parameter used to specify a different local variable
name to contain the results of the embedding process.

In many cases, only one parameter is required as in the many examples above.

#### Adding location info.

For purposes of debugging, it may be useful to tie the transpiled code to a
file or line number. This information can be added to the mini_erb object as
follows:

```ruby
file_name = "my_file.erb"
erbed = MiniErb.new(IO.read(file_name))
erbed.filename = file_name
```
This sets up the erb file and establishes its file name for debug purposes.

#### The transpiled code.

Optionally, the transpiled ruby code may be accessed using the *src* attribute.
This is most often done to verify that the transpiler is operating correctly
but is also useful to those who wish to gain insights into the operation of
the mini_erb gem. It was this same access provided by the erb library that
made this gem possible.

### Phase 2

The next step is to execute the transpiled code in an environment. This
environment is a ruby binding to the virtual location of the code execution.
In effect, code is executed as if it was placed in the spot where the binding
is taken.

This use of bindings allows access to any variables that may have been defined
in that a location and also allows the state of that location to be modified.
For example:

```ruby
x = 42
str = "x is now <%=x%>.<%x+=1%> x is now <%=x%>."
puts MiniErb.new(str).result(binding), x
```
produces

    x is now 42. x is now 43.
    43

Note how the environment was modified by adding one to x.

If no binding is specified, the binding of the top level file of the current
program is used as a default.


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
