module Yaml::Builders
  class Scalar
    include Base

    @scalar : Nodes::Scalar

    def initialize(@parent, @index, @scalar : Nodes::Scalar)
    end

    def node
      @scalar
    end

    def comment=(s : String)
      assign_leading_comment_to s, @scalar
    end

    def trailing_comment=(s : String)
      assign_trailing_comment_to s, @scalar
    end

    def assign_child_value(child, index, s : String?)
      raise Bug_IllegalAssignChildValueCall.new(self.class.name)
    end
  end
end
