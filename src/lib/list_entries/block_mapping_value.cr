module Yaml::ListEntries
  class BlockMappingValue
    include Base
    include Mapping

    def __type
      "mpv"
    end

    def initialize(@position)
    end

    def new_container
      raise UnexpectedToken.new(@position)
    end
  end
end
