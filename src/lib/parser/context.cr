module Yaml
  class Parser
    class Context
      include NodeMixins::HasLeadingComment

      getter document : Nodes::Document
      @containers = [] of ListEntryContainers::Base
      @value : Nodes::Value?

      def initialize(@document)
      end

      def last?
        @containers.last?
      end

      def last
        @containers.last
      end

      def pop
        Yaml.debug "#{" " * 9} >> #{last}"
        @containers.pop
      end

      def pop?
        @containers.pop?
      end

      def value?
        if v = @value
          @value = nil
          v
        end
      end

      def keyable?(pos)
        value!
        return true if pos.trails_empty_or_space?
        @containers.reverse_each do |l|
          case b = l.keyable?(pos)
          when Bool
            return b
          end
        end
        true
      end

      def flow?
        if last = last?
          last.flow?
        end
      end

      def append(container : ListEntryContainers::Base)
        Yaml.debug "---"
        value!
        append_ container
      end

      def append_(container : ListEntryContainers::Base)
        Yaml.debug "#{" " * 9} << #{container}"
        if last = last?
          last.append container
        else
          @document.append container.node
        end
        @containers << container
      end

      def append(entry : ListEntries::Base)
        Yaml.debug "---"
        value!
        # Yaml.debug "#{" " * 9} a  #{entry}"
        while l = last?
          if l.indents?(entry)
            entry.new_container.tap do |new_l|
              new_l.append entry
              append_ new_l
            end
            return
          elsif l.appends?(entry)
            l.append entry
            return
          else
            l.outdent
            pop
          end
        end
        entry.new_container.tap do |new_l|
          new_l.append entry
          append_ new_l
        end
      end

      def append(comma : Nodes::FlowComma)
        Yaml.debug "---"
        value!
        # Yaml.debug "#{" " * 9} a  (,):#{comma.position.line_and_column}"
        if l = last?
          l.append comma
          return
        end
        raise Bug_UnexpectedComma.new(comma.position)
      end

      def append(indicator : Nodes::FlowMappingEnd)
        Yaml.debug "---"
        value!
        # Yaml.debug "#{" " * 9} a  (}):#{indicator.position.line_and_column}"
        if l = pop?
          l.append indicator
          return
        end
        raise Bug_UnexpectedFlowMappingEnd.new(indicator.position)
      end

      def append(indicator : Nodes::FlowSequenceEnd)
        Yaml.debug "---"
        value!
        # Yaml.debug "#{" " * 9} a  (]):#{indicator.position.line_and_column}"
        if l = pop?
          l.append indicator
          return
        end
        raise Bug_UnexpectedFlowSequenceEnd.new(indicator.position)
      end

      def append(value : Nodes::Value)
        Yaml.debug do
          puts "---" if @value
        end
        value!
        # Yaml.debug "#{" " * 9} a  Val:#{value.position.line_and_column}"
        @value = value
      end

      def value!
        if v = value?
          # Yaml.debug "#{" " * 9} a! Val:#{v.position.line_and_column}"
          while l = last?
            if l.appends?(v)
              l.append v
              return
            end
            l.outdent
            pop
          end
          @document.append v
        end
      end

      def outdent
        value!
        while l = pop?
          l.outdent
        end
      end
    end
  end
end
