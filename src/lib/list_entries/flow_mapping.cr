module Yaml::ListEntries
  class FlowMapping
    include Base

    def __type
      "{?}"
    end

    getter key : Nodes::Value

    def initialize(@key)
      @position = @key.position
    end

    def new_container
      ListEntryContainers::FlowMapping.new(@position)
    end
  end
end
