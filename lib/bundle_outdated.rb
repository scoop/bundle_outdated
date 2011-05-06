require 'rubygems'
require 'bundle_outdated/gem_dependency'
require 'bundle_outdated/searcher'

module BundleOutdated
  def self.search!
     Searcher.new.search!
  end
end
