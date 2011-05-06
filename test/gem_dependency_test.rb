require 'test_helper'
require 'bundle_outdated'

class GemDependencyTest < Test::Unit::TestCase
  def setup
    stub(Gem).latest_version_for('rails') { Gem::Version.new '3.1' }
  end

  def test_name_cleanup_double_quotes
    gd = BundleOutdated::GemDependency.new 'gem "rails"'
    assert_equal 'rails', gd.name
  end

  def test_name_cleanup_single_quotes
    gd = BundleOutdated::GemDependency.new "gem 'rails'"
    assert_equal 'rails', gd.name
  end

  def test_version_cleanup
    gd = BundleOutdated::GemDependency.new 'gem "rails", "3.1"'
    assert_equal '3.1', gd.version.to_s
  end

  def test_version_garbage_cleanup
    gd = BundleOutdated::GemDependency.new 'gem "rails", :require => "rails"'
    assert_equal '', gd.version.to_s
  end

  def test_version_garbage_spermy
    gd = BundleOutdated::GemDependency.new 'gem "rails", "~> 3.1"'
    assert_equal '3.1', gd.version.to_s
  end

  def test_version_with_handwaving
    gd = BundleOutdated::GemDependency.new 'gem "rails", "~> 3.1"'
    assert gd.handwaving?
  end

  def test_version_without_handwaving
    gd = BundleOutdated::GemDependency.new 'gem "rails", "3.1"'
    assert !gd.handwaving?
  end

  def test_inspection
    gd = BundleOutdated::GemDependency.new 'gem "rails", "~> 3.1"'
    assert_equal 'rails, Version: 3.1', gd.to_s
  end

  def test_latest_version
    gd = BundleOutdated::GemDependency.new 'gem "rails"'
    assert_equal '3.1', gd.latest_version.to_s
  end

  def test_is_outdated
    gd = BundleOutdated::GemDependency.new 'gem "rails", "3.0.7"'
    assert gd.outdated?
  end

  def test_is_not_outdated
    gd = BundleOutdated::GemDependency.new 'gem "rails", "3.1"'
    assert !gd.outdated?
  end

  def test_outdated_handles_unavailable_gems
    mock(Gem).latest_version_for('rails') { nil }
    gd = BundleOutdated::GemDependency.new 'gem "rails", "3.1"'
    assert_nothing_raised {
      assert !gd.outdated?
    }
  end
end
