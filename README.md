# bundle\_outdated

## Description

A simple gem to analyze your `Gemfile` and `Gemfile.lock` to find
out which of the gems in your project have newer versions available
and thus could potentially be updated.

## Installation

    $ gem install bundle_outdated

## Usage

From your Ruby project directory or your `Rails.root`:

    $ bundle-outdated

## Example report

    Finding outdated gems..

    Newer versions found for:
      mail (2.3.0 > 2.2.18)
      hoptoad_notifier (2.4.9 > 2.3)
      devise (1.3.4 > 1.3.3)
      oa-oauth (0.2.5 > 0.2.4)
      twitter (1.4.1 > 1.4.0)
      kaminari (0.12.4 > 0.12.1)
      meta_search (1.0.5 > 1.0.4)
      paper_trail (2.2.2 > 2)
      jquery-rails (1.0 > 0.2.7)
      guard-rspec (0.3.1 > 0.3.0)

    Lock bundle to these versions by putting the following in your Gemfile:
      gem 'mail', '2.3.0'
      gem 'hoptoad_notifier', '2.4.9'
      gem 'devise', '1.3.4'
      gem 'oa-oauth', '0.2.5'
      gem 'twitter', '1.4.1'
      gem 'kaminari', '0.12.4'
      gem 'meta_search', '1.0.5'
      gem 'paper_trail', '2.2.2'
      gem 'jquery-rails', '1.0'
      gem 'guard-rspec', '0.3.1'

    You may try to update non-specific dependencies via:
      $ bundle update mail hoptoad_notifier paper_trail

    Handwaving specifications:
      mail: ~> 2.2.18
      hoptoad_notifier: ~> 2.3
      paper_trail: ~> 2

## License

Released under the MIT License.  See the LICENSE file for further details. 
