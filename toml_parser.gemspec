# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'toml_parser/version'

Gem::Specification.new do |spec|
  spec.name          = 'toml_parser'
  spec.version       = TomlParser::VERSION
  spec.authors       = ['Tomasz Skorupa']
  spec.email         = ['']

  spec.summary       = "Tom's Obvious, Minimal Language."
  spec.description   = 'Implementation of the three examples shown in ' \
                       'https://gist.github.com/sgnr/c93008864a1b2d705656'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'

  spec.add_runtime_dependency 'treetop', '~> 1.6'
  spec.add_runtime_dependency 'deep_merge', '~> 1.0'
end
