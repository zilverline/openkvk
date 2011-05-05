# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "openkvk/version"

Gem::Specification.new do |s|
  s.add_development_dependency('bundler', '~> 1.0')
  s.add_development_dependency('rake', '~> 0.8')
  s.add_development_dependency('rspec', '~> 2.3')
  s.add_development_dependency('mocha', '~> 0.9.10')
  s.add_development_dependency('simplecov', '~> 0.3')
  s.add_development_dependency('maruku', '~> 0.6')
  s.add_development_dependency('yard', '~> 0.6')
  s.add_development_dependency('hashie', '~> 1.0.0')
  s.add_development_dependency('json', '~> 1.5.1')
  
  s.name        = "openkvk"
  s.version     = OpenKVK::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Daniel van Hoesel"]
  s.email       = ["daniel@zilverline.com"]
  s.homepage    = "http://zilverline.com/"
  s.summary     = %q{Ruby wrapper for the OpenKVK api}
  s.description = %q{This is a ruby wrapper for the Dutch OpenKVK api}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
