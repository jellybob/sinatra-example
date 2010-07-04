# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "sinatra-example"
  s.version     = "1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Wood"]
  s.email       = ["jon@blankpad.net"]
  s.homepage    = "http://github.com/jellybob/sinatra-example"
  s.summary     = "A base Sinatra application, with Cucumber and RSpec"
  s.description = "This is a simple example I built while playing with Sinatra and Cucumber a bit, so that I could get to a good starting point."
  
  s.add_dependency "rack"
  s.add_dependency "sinatra"
  s.add_dependency "haml"
  
  s.add_development_dependency "shotgun"
  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "cucumber-sinatra"
  s.add_development_dependency "capybara"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.executables  = [ 'sinatra-example' ]
  s.require_path = 'lib'
end
