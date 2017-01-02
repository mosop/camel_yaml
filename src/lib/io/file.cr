module Yaml::Io
  class File
    include Loader
    include Saver

    @path : String

    def initialize(@path)
    end

    def load
      ::File.open(@path) do |f|
        Parser.new(@path, f).parse
      end
    end

    def save(stream : Stream)
      ::File.open(@path, "w") do |f|
        stream.pretty f
        f << "\n"
      end
    end

    def to_layer
      Layer.new(self, self)
    end
  end
end
