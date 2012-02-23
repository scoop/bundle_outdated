module BundleOutdated
  class GemDependency
    attr_reader :name, :version, :handwaving

    VERSION_REGEXP = /^(['"])([!~><=]*)\s*(.+?)\1$/
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
        @handwaving = !$2.empty? && $2
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
      return false unless version && latest_version
      version < latest_version
    end
  end
end
