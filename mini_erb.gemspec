lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mini_erb/version"

Gem::Specification.new do |spec|
  spec.name          = "mini_erb"
  spec.version       = MiniErb::VERSION
  spec.authors       = ["PeterCamilleri"]
  spec.email         = ["peter.c.camilleri@gmail.com"]

  spec.summary       = MiniErb::DESCRIPTION
  spec.description   = "A simplified, streamlined, pure ruby replacement for erb."
  spec.homepage      = "https://github.com/PeterCamilleri/mini_erb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
                          f.match(%r{^(test|docs)/})
                        end
  spec.bindir        = "exe"
  spec.executables   = spec
                         .files
                         .reject { |f| f.downcase == 'exe/readme.md'}
                         .grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"
end
