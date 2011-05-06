module BundleOutdated
  class Searcher
    class GemfileNotFound < StandardError; end

    def search!
      puts "Finding outdated gems.."

      unless outdated_gems.empty?
        puts "\nNewer versions found for:"
        outdated_gems.each do |gem|
          puts "  #{gem.name} (#{gem.latest_version} > #{gem.version})"
        end

        puts "\nLock bundle to these versions by putting the following in your Gemfile:"
        outdated_gems.each do |gem|
          puts "  gem '#{gem.name}', '#{gem.latest_version}'"
        end
      end

      unless handwaving_gems.empty?
        puts "\nYou may try to update non-specific dependencies via:"
        puts "  $ bundle update #{handwaving_gems.collect(&:name).join(' ')}"
        puts "\nHandwaving specifications:"
        handwaving_gems.collect do |g|
          puts "  #{g.name}: #{ [ g.handwaving, g.version ].join(' ') }"
         end
      end
    end

    def outdated_gems
      @outdated_gems ||= all_gems.find_all(&:outdated?)
    end

    def handwaving_gems
      @handwaving_gems ||= all_gems.find_all(&:handwaving?)
    end

    def gemfile
      unless File.exists?('Gemfile')
        raise GemfileNotFound, 'Gemfile not found! Please re-run in your Ruby project directory.'
      end

      @gemfile ||= File.read('Gemfile').split(/\n/)
    end

    def all_gems
      @all_gems ||= gemfile.grep(/^\s*gem\b/).collect do |gem|
        GemDependency.new gem
      end
    end
  end
end
