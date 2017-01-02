module Yaml::NodeMixins
  module HasTrailingComment
    SPACE_TAB = /^[ \t]*$/

    getter! trailing_comment : Nodes::TrailingComment?

    def append_node(node : Nodes::TrailingComment)
      @trailing_comment_string = nil
      @trailing_comment = node
    end

    def apply_trailing_comment_to(node)
      if trailing_comment = @trailing_comment
        if to = node.as?(HasTrailingComment)
          to.append_node trailing_comment
        else
          raise IllegalNodeTypeToApplyComment.new(trailing_comment.position)
        end
      end
    end

    @trailing_comment_string : String?
    def trailing_comment_string?
      @trailing_comment_string ||= if comment = @trailing_comment
        if SPACE_TAB !~ comment.string
          comment.string.rstrip
        end
      end
    end

    def put_pretty_trailing_comment?(io : IO, indent : String)
      if s = trailing_comment_string?
        io << indent
        io << "#"
        io << s
        true
      end
    end
  end
end
