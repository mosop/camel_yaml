module Yaml::ListEntries
  class BlockSequence
    include Base

    def __type
      "seq"
    end

    @indicator : Nodes::SequenceEntryIndicator

    def initialize(@indicator : Nodes::SequenceEntryIndicator)
      @position = @indicator.position
    end

    def new_container
      ListEntryContainers::BlockSequence.new(@position)
    end
  end
end
