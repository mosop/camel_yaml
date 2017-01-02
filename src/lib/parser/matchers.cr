module Yaml
  class Parser
    def skip_space?
      scan(SPACE_TAB)
    end

    def skip_space?(line_break)
      if line_break
        space_and_break?
      else
        skip_space?
      end
    end

    def skip_space_and_break?
      pos = start
      until eos?
        skip_space?
        if eol?
          next_line
          next
        end
        break
      end
      start > pos
    end

    def skip_or_basic
      if flow?
        parse_basic
      else
        skip_space?
      end
    end

    def leading_comment?
      start do |pos|
        skip_space?
        start do |pos|
          if scan("#")
            Nodes::LeadingComment.new(scan_left, position(pos))
          end
        end
      end
    end

    def trailing_comment?
      start do |pos|
        skip_space?
        start do |pos|
          if scan("#")
            Nodes::TrailingComment.new(scan_left, position(pos))
          end
        end
      end
    end

    def directive?
      start do |pos|
        if m = scan(DIRECTIVE)
          raise UnexpectedToken.new(position(pos)) if flow?
          node = if m[0].starts_with?("%YAML ")
            Nodes::YamlDirective.new(m[1], position(pos))
          elsif m[0].starts_with?("%TAG ")
            Nodes::TagDirective.new(m[1], position(pos))
          else
            Nodes::ReservedDirective.new(m[1], position(pos))
          end
          node.append_node trailing_comment?
          skip_space?
          raise UnexpectedToken.new(position) unless eol?
        end
      end
    end

    def anchor?
      start do |pos|
        skip_or_basic
        start do |pos|
          if m = scan(ANCHOR)
            Nodes::Anchor.new(m[0][1..-1], position(pos)).tap do |node|
              node.append_node trailing_comment?
            end
          end
        end
      end
    end

    def tag?
      start do |pos|
        skip_or_basic
        start do |pos|
          if m = scan(TAG)
            Nodes::Tag.new(m[0], position(pos)).tap do |node|
              node.append_node trailing_comment?
            end
          end
        end
      end
    end

    def anchor_tag
      anchor = anchor?
      tag = tag?
      anchor ||= anchor?
      {anchor, tag}
    end

    def anchor_tag_comment
      anchor, tag = anchor_tag
      {anchor, tag, trailing_comment?}
    end

    def document_start?
      start do |pos|
        if scan(DOCUMENT_START)
          raise UnexpectedToken.new(position(pos)) if flow?
          Nodes::DocumentStart.new(position(pos)).tap do |node|
            anchor, tag, comment = anchor_tag_comment
            node.append_node anchor
            node.append_node tag
            node.append_node comment
            skip_space?
            raise UnexpectedToken.new(position) unless eol?
          end
        end
      end
    end

    def document_end?
      start do |pos|
        if scan(DOCUMENT_END)
          raise UnexpectedToken.new(position(pos)) if flow?
          Nodes::DocumentEnd.new(position(pos)).tap do |node|
            node.append_node trailing_comment?
            skip_space?
            raise UnexpectedToken.new(position) unless eol?
          end
        end
      end
    end

    def append_trailing_anchor_tag_comment_to_if_any(node)
      start do |pos|
        anchor, tag, comment = anchor_tag_comment
        skip_space?
        if eol?
          node.append_node anchor
          node.append_node tag
          node.append_node comment
          true
        end
      end
    end

    def mapping_key_indicator?
      start do |pos|
        skip_space?
        start do |pos|
          if scan(MAPPING_KEY_INDICATOR)
            Nodes::MappingKeyIndicator.new(position(pos)).tap do |node|
              append_trailing_anchor_tag_comment_to_if_any node
            end
          end
        end
      end
    end

    def block_mapping_value_indicator?
      start do |pos|
        skip_space?
        start do |pos|
          if scan(MAPPING_VALUE_INDICATOR)
            Nodes::MappingValueIndicator.new(position(pos)).tap do |node|
              append_trailing_anchor_tag_comment_to_if_any node
            end
          end
        end
      end
    end

    def flow_mapping_value_indicator?
      start do |pos|
        parse_basic
        start do |pos|
          if scan(MAPPING_VALUE_INDICATOR)
            Nodes::MappingValueIndicator.new(position(pos)).tap do |node|
              node.append_node trailing_comment?
            end
          end
        end
      end
    end

    def sequence_entry_indicator?
      start do |pos|
        skip_space?
        start do |pos|
          if scan(SEQUENCE_ENTRY_INDICATOR)
            Nodes::SequenceEntryIndicator.new(position(pos)).tap do |node|
              append_trailing_anchor_tag_comment_to_if_any node
            end
          end
        end
      end
    end

    def flow_mapping_start?
      start do |loc|
        anchor, tag = anchor_tag
        skip_or_basic
        start do |loc|
          if scan("{")
            Nodes::FlowMappingStart.new(mostleft(loc, anchor, tag)).tap do |node|
              node.append_node anchor
              node.append_node tag
              node.append_node trailing_comment?
            end
          end
        end
      end
    end

    def flow_mapping_end?
      start do |pos|
        parse_basic
        if scan("}")
          Nodes::FlowMappingEnd.new(position(pos)).tap do |node|
            node.append_node trailing_comment?
          end
        end
      end
    end

    def flow_sequence_start?
      start do |loc|
        anchor, tag = anchor_tag
        skip_or_basic
        start do |loc|
          if scan("[")
            Nodes::FlowSequenceStart.new(mostleft(loc, anchor, tag)).tap do |node|
              node.append_node anchor
              node.append_node tag
              node.append_node trailing_comment?
            end
          end
        end
      end
    end

    def flow_sequence_end?
      start do |pos|
        parse_basic
        if scan("]")
          Nodes::FlowSequenceEnd.new(position(pos)).tap do |node|
            node.append_node trailing_comment?
          end
        end
      end
    end

    def flow_comma?
      start do |pos|
        parse_basic
        if scan(",")
          Nodes::FlowComma.new(position(pos)).tap do |node|
            node.append_node trailing_comment?
          end
        end
      end
    end

    def alias?
      start do |pos|
        skip_or_basic
        start do |pos|
          if m = scan(ALIAS)
            Nodes::Alias.new(m[0][1..-1], position(pos)).tap do |node|
              node.append_node trailing_comment?
            end
          end
        end
      end
    end

    def double_quoted?
      start do |pos|
        anchor, tag = anchor_tag
        skip_or_basic
        start do |pos|
          if scan("\"")
            pos = mostleft(pos, anchor, tag)
            Nodes::DoubleQuotedString.new(build_double_quoted(pos), pos).tap do |node|
              node.append_node anchor
              node.append_node tag
              node.append_node trailing_comment?
            end
          end
        end
      end
    end

    def build_double_quoted(pos)
      String.build do |builder|
        build_double_quoted2 pos, builder
      end
    end

    def build_double_quoted2(pos, builder)
      until eos?
        if scan("\"")
          return
        elsif scan("\\0")
          builder << "\u{0}"
        elsif scan("\\a")
          builder << "\u{7}"
        elsif scan("\\b")
          builder << "\u{8}"
        elsif scan("\\t")
          builder << "\u{9}"
        elsif scan("\\a")
          builder << "\u{7}"
        elsif scan("\\n")
          builder << "\u{a}"
        elsif scan("\\v")
          builder << "\u{b}"
        elsif scan("\\f")
          builder << "\u{c}"
        elsif scan("\\r")
          builder << "\u{d}"
        elsif scan("\\e")
          builder << "\u{1b}"
        elsif scan("\\ ")
          builder << " "
        elsif scan("\\\"")
          builder << "\""
        elsif scan("\\/")
          builder << "/"
        elsif scan("\\\\")
          builder << "\\"
        elsif scan("\\N")
          builder << "\u{85}"
        elsif scan("\\_")
          builder << "\u{a0}"
        elsif scan("\\L")
          builder << "\u{2028}"
        elsif scan("\\P")
          builder << "\u{2029}"
        elsif match = scan(UNICODE_ESCAPE8) || scan(UNICODE_ESCAPE16) || scan(UNICODE_ESCAPE32)
          builder << match[1].to_i32(base: 16).unsafe_chr.to_s
        else
          builder << scan(1).not_nil!
        end
      end
      raise QuotedStringNotEnded.new(pos)
    end

    def single_quoted?
      start do |pos|
        anchor, tag = anchor_tag
        skip_or_basic
        start do |pos|
          if scan("'")
            pos = mostleft(pos, anchor, tag)
            Nodes::SingleQuotedString.new(build_single_quoted(pos), pos).tap do |node|
              node.append_node anchor
              node.append_node tag
              node.append_node trailing_comment?
            end
          end
        end
      end
    end

    def build_single_quoted(pos)
      String.build do |builder|
        build_single_quoted2 pos, builder
      end
    end

    def build_single_quoted2(pos, builder)
      until eos?
        if scan("''")
          builder << "'"
        elsif scan("'")
          return
        else
          builder << scan(1).not_nil!
        end
      end
      raise QuotedStringNotEnded.new(pos)
    end

    def unquoted?
      start do |pos|
        anchor, tag = anchor_tag
        skip_or_basic
        start do |pos|
          pos = mostleft(pos, anchor, tag)
          s = build_unquoted(pos)
          if !s.empty?
            Nodes::UnquotedString.new(s, pos).tap do |node|
              node.append_node anchor
              node.append_node tag
              node.append_node trailing_comment?
            end
          end
        end
      end
    end

    def build_unquoted(pos)
      String.build do |builder|
        build_unquoted2 pos, builder
      end
    end

    def build_unquoted2(pos, builder)
      keyable = context.keyable?(pos)
      flow = flow?
      space = keyable ? KEYABLE_SCALAR_SPACE : SCALAR_SPACE
      until eol?
        return if test(SPACE_TAB) && !test(space)
        return if flow && test(",")
        return if flow == :map && test("}")
        return if flow == :seq && test("]")
        return if keyable && test(KEYABLE_COLON)
        builder << scan(1).not_nil!
      end
    end
  end
end
