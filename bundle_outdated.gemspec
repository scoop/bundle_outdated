# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bundle_outdated/version"

Gem::Specification.new do |s|
  s.name        = "bundle_outdated"
  s.version     = BundleOutdated::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Patrick Lenz"]
  s.email       = ["patricklenz@gmail.com"]
  s.homepage    = "https://github.com/scoop/bundle_outdated"
  s.summary     = %q{Find out which gems in your bundle are outdated.}
  s.description = %q{Find out which gems in your bundle are outdated.}

  s.rubyforge_project = "bundle_outdated"

  s.add_dependency 'rr', '~> 1.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
