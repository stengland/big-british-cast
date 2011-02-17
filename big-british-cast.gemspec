# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "big-british-cast"
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve England"]
  s.email       = ["stephen.england@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Podcasts for the Big British Castle}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "big-british-cast"
  s.add_dependency('sinatra', '~> 1.1')
  s.add_dependency('feedzirra', '~> 0.0.24')
  s.add_dependency('i18n')

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "rack-test"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
