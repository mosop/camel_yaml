module Yaml::ListEntries
  class FlowSequence
    include Base

    def __type
      "[?]"
    end

    def new_container
      ListEntryContainers::FlowSequence.new(@position)
    end

    def initialize(@position)
    end
  end
end
