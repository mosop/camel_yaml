module Yaml::ListEntryContainers
  abstract class Base
    class Mismatch < Exception
      def initialize(this, target)
        super "[BUG] Mismatch: #{this.class.name}(#{this.position.line_and_column}) with #{target.class.name}(#{target.position.line_and_column})"
      end
    end

    include NodeMixins::HasPosition
    include NodeMixins::HasAnchor
    include NodeMixins::HasTag
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment

    def initialize(@position)
    end

    def to_s(io : IO)
      io << "#{__type}:#{position.line_and_column}"
    end

    def append_node(node : Nil)
    end

    def indents?(entry : ListEntries::BlockMapping)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def indents?(entry : ListEntries::BlockMappingKey)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def indents?(entry : ListEntries::BlockMappingValue)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def indents?(entry : ListEntries::BlockSequence)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def indents?(entry : ListEntries::FlowMapping)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def indents?(entry : ListEntries::FlowSequence)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def appends?(entry : ListEntries::BlockMapping)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def appends?(entry : ListEntries::BlockMappingKey)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def appends?(entry : ListEntries::BlockMappingValue)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def appends?(entry : ListEntries::BlockSequence)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def appends?(entry : ListEntries::FlowMapping)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def appends?(entry : ListEntries::FlowSequence)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry}"
      raise Mismatch.new(self, entry)
    end

    def append(entry : ListEntries::BlockMapping)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      raise Mismatch.new(self, entry)
    end

    def append(entry : ListEntries::BlockMappingKey)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      raise Mismatch.new(self, entry)
    end

    def append(entry : ListEntries::BlockMappingValue)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      raise Mismatch.new(self, entry)
    end

    def append(entry : ListEntries::BlockSequence)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      raise Mismatch.new(self, entry)
    end

    def append(entry : ListEntries::FlowMapping)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      raise Mismatch.new(self, entry)
    end

    def append(entry : ListEntries::FlowSequence)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      raise Mismatch.new(self, entry)
    end

    def append(container : ListEntryContainers::Base)
      Yaml.debug "#{self.to_s.ljust(9)} c  #{container}"
      append container.node
    end

    def append(comma : Nodes::FlowComma | Nodes::FlowMappingEnd | Nodes::FlowSequenceEnd)
      raise Mismatch.new(self, comma)
    end

    def apply_entry_to(entry, to)
      entry.apply_anchor_to to
      entry.apply_tag_to to
    end
  end
end
