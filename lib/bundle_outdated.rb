module BundleOutdated
  def self.search!
     Searcher.new.search!
  end

  class GemDependency
    attr_reader :name, :version, :handwaving

    VERSION_REGEXP = /^(['"])([~><=])*\s*(.+?)\1$/
    GEMNAME_REGEXP = /gem\s(['"])(.+?)\1/

    def initialize(gemfile_string)
      self.name, self.version = gemfile_string.split(/,\s*/)
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
        @handwaving = !!$2
        @version = Gem::Version.new($3)
      end
    end

    def handwaving?; !!handwaving; end

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

    def search!
      all_gems.find_all(&:outdated?).each do |gem|
        puts "#{gem.name} (#{gem.latest_version} > #{gem.version})"
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
        GemDependency.new gem
      end
    end
  end
end
