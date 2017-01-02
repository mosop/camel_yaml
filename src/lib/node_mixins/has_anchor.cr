module Yaml::NodeMixins
  module HasAnchor
    getter! anchor : Nodes::Anchor?

    def append_node(node : Nodes::Anchor)
      raise TooManyAnchor.new(node.position) if @anchor
      @anchor = node
    end

    def apply_anchor_to(node)
      if anchor = @anchor
        if to = node.as?(HasAnchor)
          to.append_node anchor
        else
          raise IllegalNodeTypeToApplyAnchor.new(anchor.position)
        end
      end
    end

    def anchor_name?
      if anchor = @anchor
        anchor.anchor_name
      end
    end

    def put_pretty_anchor?(io : IO, indent : String)
      if s = anchor_name?
        io << indent
        io << "&"
        io << s
        true
      end
    end
  end
end
