module Yaml::Builders
  class MappingEntry
    include Base

    @mapping_entry : Nodes::MappingEntry

    def initialize(@parent, @index, @mapping_entry : Nodes::MappingEntry)
    end

    def node
      @mapping_entry
    end

    def default_target
      @mapping_entry.value
    end

    def seq
      seq = if v = @mapping_entry.value
        if v = v.as?(Nodes::Sequence)
          v
        end
      end
      seq ||= Nodes::Sequence.new(position).tap do |seq|
        @mapping_entry.value = seq
      end
      yield Sequence.new(self, 1, seq)
    end

    def value=(s : String?)
      @mapping_entry.change
      @mapping_entry.value = Nodes::Scalar.new_string_scalar(s, position)
    end

    def comment=(s : String)
      assign_leading_comment_to s, @mapping_entry.value
    end

    def trailing_comment=(s : String)
      assign_trailing_comment_to s, @mapping_entry.value
    end

    def assign_child_value(child, index, s : String?)
      @mapping_entry.change
      s = Nodes::Scalar.new_string_scalar(s, position)
      if index == 0
        @mapping_entry.key = s
      else
        @mapping_entry.value = s
      end
    end
  end
end
