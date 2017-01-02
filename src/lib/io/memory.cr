module Yaml::Io
  class Memory
    include Loader

    @text : String

    def initialize(@text)
    end

    def load
      Parser.new("(memory)", IO::Memory.new(@text)).parse
    end
  end
end
