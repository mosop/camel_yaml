module Yaml::Io
  class File
    include Loader
    include Saver

    @path : String
    @permission : Int32?
    @stream : Stream?

    def initialize(@path, @stream = nil, @permission = nil)
    end

    def load
      @stream || begin
        ::File.open(@path) do |f|
          Parser.new(@path, f).parse
        end
      end
    end

    def save(stream : Stream)
      Dir.mkdir_p ::File.dirname(@path)
      ::File.open(@path, "w") do |f|
        stream.pretty f
        f << "\n"
      end
      if perm = @permission
        ::File.chmod @path, perm
      end
    end

    def to_layer
      if stream = @stream
        Layer.new(StreamProvider.new(stream, self))
      else
        Layer.new(StreamProvider.new(self, self))
      end
    end
  end
end
