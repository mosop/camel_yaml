module Yaml
  class Parser
    @source : Source
    @future : Concurrent::Future(Nil)
    @line = 0
    @column = 0
    @current_line : String?
    getter! match : Regex::MatchData?
    getter! context : Context

    def initialize(location, io)
      @stream = Stream.new(location)
      @source = Source.new(location)
      @future = start_to_read(io)
      @current_line = get_line
    end

    def debug
      "#{position}\n#{@current_line}\n#{" " * @column}^"
    end

    def flow?
      context.flow?
    end

    def parse
      doc_start = nil
      until eos?
        next if skip_space_and_break?
        doc = Nodes::Document.new(doc_start, position)
        @context = Context.new(doc)
        @stream.documents << doc
        begin
          parse_document
        rescue ex : StartDocument
          doc_start = ex.node?
        rescue ex : Eos
          break
        ensure
          context.outdent
        end
      end
      @stream.documents << Nodes::Document.undefined(@stream.location) if @stream.documents.empty?
      @stream
    end

    def parse_document
      loop do
        parse_basic
        if found = scan_content
          context.append found
        else
          raise UnexpectedToken.new(position)
        end
      end
    end

    def parse_basic
      until eos?
        next if skip_space_and_break?
        if found = leading_comment?
          context.append_node found
        elsif found = directive?
          context.apply_leading_comment_to found
          context.document.append_node found
        elsif found = document_start?
          context.apply_leading_comment_to found
          if context.document.started?
            raise StartDocument.new(found)
          else
            context.document.start = found
          end
        elsif found = document_end?
          context.apply_leading_comment_to found
          context.document.end = found
          raise StartDocument.new(nil)
        else
          return
        end
      end
      raise Eos.new
    end

    def scan_content
      case context.flow?
      when :map
        scan_flow_mapping_content
      when :seq
        scan_flow_sequence_content
      else
        scan_block_content
      end
    end

    def scan_block_content
      scan_complex_block_mapping ||
      scan_block_mapping_or_value_indicator ||
      scan_block_sequence ||
      scan_value
    end

    def scan_complex_block_mapping
      if indicator = mapping_key_indicator?
        ListEntries::BlockMappingKey.new(indicator.position).tap do |l|
          indicator.apply_anchor_to l
          indicator.apply_tag_to l
          indicator.apply_trailing_comment_to l
        end
      end
    end

    def scan_block_mapping_or_value_indicator
      if indicator = block_mapping_value_indicator?
        if indicator.trails_empty_or_space?
          ListEntries::BlockMappingValue.new(indicator.position).tap do |l|
            indicator.apply_anchor_to l
            indicator.apply_tag_to l
            indicator.apply_trailing_comment_to l
          end
        else
          if v = context.value?
            ListEntries::BlockMapping.new(v).tap do |entry|
              indicator.apply_anchor_to entry
              indicator.apply_tag_to entry
              indicator.apply_trailing_comment_to entry
            end
          else
            raise UnexpectedToken.new(indicator.position)
          end
        end
      end
    end

    def scan_block_sequence
      if indicator = sequence_entry_indicator?
        ListEntries::BlockSequence.new(indicator).tap do |entry|
          indicator.apply_anchor_to entry
          indicator.apply_tag_to entry
          indicator.apply_trailing_comment_to entry
        end
      end
    end

    def scan_flow_mapping_content
      flow_comma? ||
      flow_mapping_end? ||
      scan_flow_mapping_entry ||
      scan_value
    end

    def scan_flow_mapping_entry
      if indicator = flow_mapping_value_indicator?
        key = context.value? || Nodes::Null.new(indicator.position)
        indicator.apply_trailing_comment_to key
        ListEntries::FlowMapping.new(key)
      end
    end

    def scan_flow_sequence_content
      flow_comma? ||
      flow_sequence_end? ||
      scan_value
    end

    def scan_value
      alias? ||
      double_quoted? ||
      single_quoted? ||
      scan_flow_mapping ||
      scan_flow_sequence ||
      unquoted?
    end

    def scan_flow_mapping
      if indicator = flow_mapping_start?
        l = ListEntryContainers::FlowMapping.new(indicator.position).tap do |l|
          indicator.apply_anchor_to l
          indicator.apply_tag_to l
          indicator.apply_trailing_comment_to l
        end
        context.append l
        parse_document
        l.node
      end
    end

    def scan_flow_sequence
      if indicator = flow_sequence_start?
        l = ListEntryContainers::FlowSequence.new(indicator.position).tap do |l|
          indicator.apply_anchor_to l
          indicator.apply_tag_to l
          indicator.apply_trailing_comment_to l
        end
        context.append l
        parse_document
        l.node
      end
    end
  end
end

require "./parser/*"
