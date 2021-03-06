require_relative "mini_erb/version"

# A simplified, streamlined erb replacement.
class MiniErb

  # The Ruby code generated by mini erb.
  attr_reader :src

  # The optional file name used when the mini_erb code is run.
  attr_accessor :filename

  # The optional line number used when the mini_erb code is run.
  attr_accessor :lineno

  # Set the file name and optional line number associated with the compiled code.
  def location=((filename, lineno))
    @filename = filename
    @lineno = lineno if lineno
  end

  # Create a mini_erb object. Spurious parameter is for erb compatibility.
  def initialize(string, safe_level=nil, _=nil, eoutvar='_erbout')
    @safe_level, @eoutvar = safe_level, eoutvar
    @filename, @lineno = "(mini_erb)", 0
    @src = compile(string)
  end

  # Compile the mini erb input
  def compile(string)
    buffer, suppress = [], false

    until string.empty?
      text, code, string = string.partition(/<%.*?%>/m)

      text.sub!(/\A$\r?\n?/, "") if suppress
      buffer << "#{@eoutvar}<<#{text.inspect};" unless text.empty?

      unless code.empty?
        end_point = (suppress = code[-3] == "-") ? -3 : -2

        unless code[2] == "#"
          if code[2] == "="
            buffer << "#{@eoutvar}<<(#{code[3...end_point]}).to_s;"
          else
            buffer << "#{code[2...end_point]};"
          end
        end
      end
    end

    @eoutvar + "=String.new;" + buffer.join + @eoutvar
  end

  # Return the mini erb text with embedded Ruby results.
  def result(evaluator = new_toplevel)
    if @safe_level
      proc {$SAFE = @safe_level; eval(@src, evaluator, @filename, @lineno)}.call
    else
      eval(@src, evaluator, @filename, @lineno)
    end
  end

  # Generate results and print them.
  def run(evaluator = new_toplevel)
    print result(evaluator)
  end

private

  # Get a duplicate of the default binding if none is specified.
  def new_toplevel
    TOPLEVEL_BINDING.dup
  end
end
