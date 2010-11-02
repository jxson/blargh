# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "blargh/version"

Gem::Specification.new do |s|
  s.name        = "blargh"
  s.version     = Blargh::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Campbell"]
  s.email       = ["jason@greatergood.cc"]
  s.homepage    = "http://rubygems.org/gems/blargh"
  s.summary     = %q{yet another blogging engine...}
  s.description = %q{highly configurable, expandable, and easy to use}

  s.rubyforge_project = "blargh"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency "rspec", "~> 2.0.1"
  s.add_development_dependency "cucumber", "~> 0.9.3"
  s.add_development_dependency "aruba", "~> 0.2.3"
  s.add_development_dependency "sparky", "~> 0.0.1"
end
