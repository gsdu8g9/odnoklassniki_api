# -*- encoding: utf-8 -*-
require File.expand_path('../lib/odnoklassniki_api/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "odnoklassniki_api"
  s.version     = OdnoklassnikiAPI::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Natalia Sergeeva"]
  s.email       = ["natalia.m.sergeeva@gmail.com"]
  s.homepage    = "https://github.com/miliru/odnoklassniki_api"
  s.summary     = %q{}
  s.description = %q{}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'faraday_middleware'
  s.add_runtime_dependency 'hashie', '>= 1.2.0'
  s.add_runtime_dependency 'multi_json', '~> 1.5.0'

  s.add_development_dependency("bundler")
  s.add_development_dependency("webmock", '~> 1.9.0')
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec", "~> 2.6")
  s.add_development_dependency("yard", '>= 0.7.1')
  s.add_development_dependency 'pry'
end
