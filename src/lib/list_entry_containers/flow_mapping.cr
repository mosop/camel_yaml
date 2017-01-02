module Yaml::ListEntryContainers
  class FlowMapping < Base
    def __type
      "{*}"
    end

    @entries = [] of ListEntries::FlowMapping
    @containers = [] of ListEntryContainers::Base
    @comma = false
    @end = false

    @node : Nodes::Mapping?
    def node
      @node ||= Nodes::Mapping.new(@position)
    end

    def flow?
      :map
    end

    def indents?(entry : ListEntries::FlowMapping)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry}"
      false
    end

    def appends?(entry : ListEntries::FlowMapping)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry}"
      true
    end

    def appends?(value : Nodes::Value)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{value}"
      true
    end

    def append(entry : ListEntries::FlowMapping)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      raise UnexpectedToken.new(entry.position) if !node.entries.empty? && !@comma
      @comma = false
      @entries << entry
    end

    def append(value : Nodes::Value)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{value}"
      raise UnexpectedToken.new(value.position) if @entries.empty?
      entry = @entries.pop
      node.append entry.key, value
    end

    def append(comma : Nodes::FlowComma)
      Yaml.debug "#{self.to_s.ljust(9)} a  (,):#{comma.position.line_and_column}"
      raise UnexpectedComma.new(comma.position) if node.entries.empty? || @comma
      if entry = @entries.pop?
        node.append entry.key, Nodes::Null.new(comma.position)
      end
      @comma = true
    end

    def append(indicator : Nodes::FlowMappingEnd)
      Yaml.debug "#{self.to_s.ljust(9)} a  (}):#{indicator.position.line_and_column}"
      raise UnexpectedFlowMappingEnd.new(indicator.position) if @comma
      if entry = @entries.pop?
        node.append entry.key, Nodes::Null.new(indicator.position)
      end
      @end = true
    end

    def outdent
      raise MappingNotEnded.new(position) unless @end
    end

    def keyable?(pos)
      true
    end
  end
end
