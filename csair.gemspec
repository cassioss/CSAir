# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csair/version'

Gem::Specification.new do |spec|
  spec.name          = 'csair'
  spec.version       = Csair::VERSION
  spec.authors       = ['Cassio Sousa']
  spec.email         = ['cassiosantossousa@gmail.com']

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  end

  spec.summary       = %q{CSAir}
  spec.description   = %q{Ruby gem that analyzes routes between airports.}
  spec.homepage      = 'https://github.com/cassioss/csair'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'json'
end
