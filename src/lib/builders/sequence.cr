module Yaml::Builders
  class Sequence
    include Base

    @sequence : Nodes::Sequence

    def initialize(@parent, @index, @sequence : Nodes::Sequence)
    end

    def node
      @sequence
    end

    def [](index : Int32)
      (@sequence.entries[index]? || @sequence.fallback_entry(index)).new_builder(self, index)
    end

    def s(s : String)
      @sequence.append Nodes::Scalar.new_string_scalar(s, position)
    end

    def comment=(s : String)
      assign_leading_comment_to s, @sequence
    end

    def trailing_comment=(s : String)
      assign_trailing_comment_to s, @sequence
    end

    def assign_child_value(child, index, s : String?)
      raise Bug_IllegalAssignChildValueCall.new(self.class.name)
    end
  end
end
