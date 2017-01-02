module Yaml::ListEntries
  module Base
    include NodeMixins::HasPosition
    include NodeMixins::HasAnchor
    include NodeMixins::HasTag
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment

    def to_s(io : IO)
      io << "#{__type}:#{position.line_and_column}"
    end

    def append_node(node : Nil)
    end

    def apply_to(value : Nodes::Value)
      apply_anchor_to value
      apply_tag_to value
    end
  end
end
