module Yaml::Builders
  class SequenceEntry
    include Base

    @sequence_entry : Nodes::SequenceEntry

    def initialize(@parent, @index, @sequence_entry : Nodes::SequenceEntry)
    end

    def node
      @sequence_entry
    end

    def default_target
      @sequence_entry.value
    end

    def value=(s : String?)
      @sequence_entry.value = Nodes::Scalar.new_string_scalar(s, position)
    end

    def comment=(s : String)
      assign_leading_comment_to s, @sequence_entry.value
    end

    def trailing_comment=(s : String)
      assign_trailing_comment_to s, @sequence_entry.value
    end

    def assign_child_value(child, index, s : String?)
      @sequence_entry.value = Nodes::Scalar.new_string_scalar(s, position)
    end
  end
end
