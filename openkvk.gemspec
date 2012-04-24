# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "openkvk/version"

Gem::Specification.new do |s|
  s.add_development_dependency('bundler')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('mocha')
  s.add_development_dependency('simplecov')
  s.add_development_dependency('maruku')
  s.add_development_dependency('yard')
  s.add_dependency('hashie')
  s.add_dependency('json')
  
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
