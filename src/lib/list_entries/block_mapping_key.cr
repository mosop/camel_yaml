module Yaml::ListEntries
  class BlockMappingKey
    include Base
    include Mapping

    def __type
      "mpk"
    end

    def initialize(@position)
    end

    def new_container
      ListEntryContainers::BlockMapping.new(@position)
    end

    getter? value : Nodes::Value?

    def value=(value)
      @value = value
      apply_anchor_to value
      apply_tag_to value
    end
  end
end
