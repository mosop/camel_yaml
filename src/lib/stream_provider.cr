module Yaml
  class StreamProvider
    @stream : Stream?
    @loader : Io::Loader?
    @saver : Io::Saver?

    def initialize(loader_saver : Io::LoaderSaver)
      @loader = loader_saver
      @saver = loader_saver
    end

    def initialize(@loader : Io::Loader)
    end

    def initialize(@loader : Io::Loader, @saver : Io::Saver)
    end

    def initialize(@stream : Stream)
    end

    def initialize(@stream : Stream, @saver : Io::Saver)
    end

    def stream
      @stream ||= if loader = @loader
        loader.load
      else
        Yaml.parse("")
      end
    end

    def save
      if saver = @saver
        saver.save stream
      end
    end
  end
end
