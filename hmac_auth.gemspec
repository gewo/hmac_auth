# encoding: utf-8
require File.expand_path('../lib/hmac_auth/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'hmac_auth'
  gem.version       = HMACAuth::VERSION
  gem.authors       = ['Gebhard Wöstemeyer']
  gem.email         = ['g.woestemeyer@gmail.com']
  gem.description   = 'HMAC based message signing and verification'
  gem.summary       = 'Ruby gem providing HMAC based message signing and ' \
                      'verification. Without fancy Rails integration.'
  gem.homepage      = 'https://github.com/gewo/hmac_auth'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'activesupport'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'coveralls'
end
