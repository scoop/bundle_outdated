module BundleOutdated
  def self.search!
     Searcher.search!
  end

  class GemDependency
    attr_reader :name, :version

    VERSION_REGEXP = /^(['"])[~><=]*\s*(.+?)\1$/
    GEMNAME_REGEXP = /gem\s(['"])(.+?)\1/

    def initialize(name, version)
      self.name = name
      self.version = version
    end

    def name=(new_name)
      @name = nil
      if new_name && new_name.match(GEMNAME_REGEXP)
        @name = $2
      end
    end

    def version=(new_version)
      @version = nil
      if new_version && new_version.match(VERSION_REGEXP)
        @version = Gem::Version.new($2)
      end
    end

    def to_s
      "#{name}, Version: #{ version || 'Any' }"
    end

    def latest_version
      @latest_version ||= Gem.latest_version_for(name)
    end

    def outdated?
      return false unless version
      version < latest_version
    end
  end

  class Searcher
    class GemfileNotFound < StandardError; end

    def self.search!
      searcher = new
    end

    def initialize
      all_gems.each do |gem|
        if gem.outdated?
          puts "#{gem.name} (#{gem.latest_version} > #{gem.version})"
        end
      end
    end

    def gemfile
      unless File.exists?('Gemfile')
        raise GemfileNotFound, 'Gemfile not found! Please re-run in your Ruby project directory.'
      end

      @gemfile ||= File.read('Gemfile').split(/\n/)
    end

    def all_gems
      gemfile.grep(/^gem\b/).collect do |gem|
        gemname, version = gem.split(/,\s*/)
        GemDependency.new gemname, version
      end
    end
  end
end
