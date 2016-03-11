require File.join(File.dirname(__FILE__), "lib", "controller_less", "version")

Gem::Specification.new do |s|
  s.name          = 'controller_less'
  s.license       = 'MIT'
  s.version       = ControllerLess::VERSION
  s.homepage      = 'https://github.com/victorcreed/controller_less'
  s.authors       = ['Kamal Ejaz']
  s.email         = ['a2ninek@yahoo.com']
  s.description   = 'micro library to dry out basic crud rails controllers.'
  s.summary       = 'micro library to dry out basic crud rails controllers.'

  s.files         = `git ls-files`.split("\n").sort
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'inherited_resources', '~> 1.6'
  s.add_dependency 'rails',               '>= 3.2', '< 5.0'
end
