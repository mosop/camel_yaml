module Yaml::NodeMixins
  module HasLeadingComment
    SPACE_TAB = /^[ \t]*$/

    @leading_comments = [] of Nodes::LeadingComment

    def append_node(node : Nodes::LeadingComment)
      @leading_comment_strings = nil
      @leading_comments << node
    end

    def apply_leading_comment_to(node)
      if !@leading_comments.empty?
        if to = node.as?(HasLeadingComment)
          @leading_comments.each do |comment|
            to.append_node comment
          end
        else
          raise IllegalNodeTypeToApplyComment.new(@leading_comments.first.position)
        end
      end
    end

    @leading_comment_strings : Array(String)?
    def leading_comment_strings
      @leading_comment_strings ||= begin
        a = @leading_comments.map{|i| i.string}
        while l = a.first?
          break if SPACE_TAB !~ l
          a.shift
        end
        while l = a.last?
          break if SPACE_TAB !~ l
          a.pop
        end
        a
      end
    end

    def put_pretty_leading_comment?(io : IO, indent : String, first_indent : String? = nil)
      lcs = leading_comment_strings
      unless lcs.empty?
        lcs.each.first(1).each do |s|
          io << "\n" if first_indent
          io << indent
          io << "#"
          io << s
        end
        lcs.each.skip(1).each do |s|
          io << "\n"
          io << indent
          io << "#"
          io << s
        end
        true
      end
    end
  end
end
