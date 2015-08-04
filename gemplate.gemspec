$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require "gemplate/version"

Gem::Specification.new do |s|
  s.name        = 'gemplate'
  s.version     = Gemplate::VERSION.dup
  s.date        = Gemplate::RELEASE_DATE.dup
  s.summary     = "Gemplate!"
  s.description = "A template for my gems!"
  s.authors     = ["Craig Waterman"]
  s.email       = 'craigwaterman@gmail.com'
  s.homepage    =
      'http://rubygems.org/gems/gemplate'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec',   '~> 3.1'
  s.add_development_dependency 'guard-rspec', '~> 4.4'
end
