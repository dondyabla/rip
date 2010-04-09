module Rip
  class Package
    def self.handle?(source)
      false
    end

    def self.handlers
      [ GitPackage, GemPackage ]
    end

    def self.from_hash(hash)
      handler = handlers.detect do |klass|
        klass.handle? hash[:source]
      end

      return nil if handler.nil?

      package = handler.new(hash.delete(:source))

      # Special key.
      package.dependencies = Array(hash.delete(:dependencies)).map do |dep|
        from_hash(dep)
      end

      hash.each do |key, value|
        package.send("#{key}=", value)
      end

      package
    end

    attr_accessor :path, :source, :version, :actual_version
    attr_accessor :name, :dependencies, :files

    def initialize(source, path = nil, version = nil, actual_version = nil)
      @source         = source
      @path           = path || "/"
      @version        = version
      @actual_version = actual_version
      @files          = []

      @dependencies = []
    end

    def package_name
      "#{name}-#{Rip.md5("#{source}#{path}#{version}")}"
    end

    def package_path
      "#{Rip.packages}/#{package_name}"
    end

    def to_s
      "#{name} (#{version})"
    end

    def to_rip
      ripfile = []
      ripfile << source
      ripfile << version if version
      ripfile << path    if path != '/'

      ripfile * ' '
    end
  end
end
