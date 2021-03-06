# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "moranis/version"

Gem::Specification.new do |s|
  s.name        = "moranis"
  s.version     = Moranis::VERSION
  s.authors     = ["Bill Chapman"]
  s.email       = ["byllc@overnothing.com"]
  s.homepage    = "https://github.com/byllc/moranis"
  s.summary     = %q{ SSH Key management for teams}
  s.description = %q{ Standalone centralized ssh key management for teams }

  s.rubyforge_project = "moranis"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "minitest"
end

