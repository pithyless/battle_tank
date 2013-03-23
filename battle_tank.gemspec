# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'battle_tank/version'

Gem::Specification.new do |gem|
  gem.name          = "battle_tank"
  gem.version       = BattleTank::VERSION
  gem.authors       = ["Norbert Wojtowicz", "Pawel Niemczyk"]
  gem.email         = ["wojtowicz.norbert@gmail.com"]
  gem.description   = "Battle Tanks"
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'ffi-rzmq', '~> 1.0.0'
  gem.add_dependency 'bert', '~> 1.1.6'
end
