module Yaml::ListEntries
  class BlockMapping
    include Base
    include Mapping

    def __type
      "map"
    end

    def initialize(key : Nodes::Value)
      @key = key
      @position = key.position
    end

    def new_container
      ListEntryContainers::BlockMapping.new(@position)
    end
  end
end
