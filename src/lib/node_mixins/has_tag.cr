module Yaml::NodeMixins
  module HasTag
    getter! tag : Nodes::Tag?

    def append_node(node : Nodes::Tag)
      raise TooManyTag.new(node.position) if @tag
      @tag = node
    end

    def apply_tag_to(node)
      if tag = @tag
        if to = node.as?(HasTag)
          to.append_node tag
        else
          raise IllegalNodeTypeToApplyTag.new(tag.position)
        end
      end
    end

    def tag_string?
      if tag = @tag
        tag.string
      end
    end

    def put_pretty_tag?(io : IO, indent : String)
      if s = tag_string?
        io << indent
        io << s
        true
      end
    end
  end
end
