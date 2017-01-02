module Yaml::Builders
  module Base
    alias Type = Mapping | Sequence | Scalar | MappingEntry | SequenceEntry
    alias Node = Nodes::Mapping | Nodes::Sequence | Nodes::MappingEntry

    @parent : Type?
    getter! index : Int32 | String | Nil

    def root
      if parent = @parent
        parent.root
      else
        self
      end
    end

    def position
      root.node.document.position
    end

    def assign_leading_comment_to(comment : String, to)
      comment.split("\n").each do |s|
        to.append_node Nodes::LeadingComment.new(s, position)
      end
    end

    def assign_trailing_comment_to(comment : String, to)
      to.append_node Nodes::TrailingComment.new(comment, position)
    end

    def value=(value : String?)
      if parent = @parent
        parent.assign_child_value self, index, value
      else
        raise CantReassignRootNode.new
      end
    end
  end
end
