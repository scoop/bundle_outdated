require 'test_helper'
require 'bundle_outdated'

class SearcherTest < Test::Unit::TestCase
  def setup
    stub(File).read('Gemfile') { "gem 'rails', '~> 3.0'" }
    stub(Gem).latest_version_for('rails') { '3.1' }
    @searcher = BundleOutdated::Searcher.new
  end

  def test_all_gems_creates_gem_dependencies
    assert_kind_of BundleOutdated::GemDependency, @searcher.all_gems.first
  end

  def test_all_gems_ignores_lines_without_gem
    mock(File).read('Gemfile') { "source 'gemcutter.org'\ngem 'rails', '~> 3.0'" }
    assert_equal 1, @searcher.all_gems.size
  end

  def test_gemfile_raises_error_if_no_gemfile_found
    mock(File).exists?('Gemfile') { false }
    assert_raises(BundleOutdated::Searcher::GemfileNotFound) {
      @searcher.search!
    }
  end

  def test_gemfile_reads_and_splits_gemfile
    mock(File).read('Gemfile') { "gem 'rails', '3.0'" }
    assert_equal ["gem 'rails', '3.0'"], @searcher.gemfile
  end

  def test_search_finds_all_outdated_gems
    assert_equal 'rails', @searcher.all_gems.first.name
  end
end
