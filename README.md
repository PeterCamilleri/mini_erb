# MiniErb

The mini_erb gem is another spin off from the mysh project. In testing the
handlebars embedded Ruby system used there, it was observed that the test
code was faster than both the native erb and the faster erubi.

The mini_erb gem returns to the syntax of erb based on the same algorithm of
the mysh handlebars.

In performance it is still faster. This is laid out in this
[report](https://github.com/PeterCamilleri/mini_erb/blob/master/docs/embbed_ruby_study.pdf)
.

#### Differences from erb.

For reasons of speed, mini_erb supports a subset of the functionality of erb.
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
