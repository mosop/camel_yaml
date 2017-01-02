module Yaml::ListEntryContainers
  class FlowSequence < Base
    def __type
      "[*]"
    end

    @comma = false
    @end = false

    @node : Nodes::Sequence?
    def node
      @node ||= Nodes::Sequence.new(@position)
    end

    def flow?
      :seq
    end

    def appends?(value : Nodes::Value)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{value}"
      true
    end

    def append(value : Nodes::Value)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{value}"
      raise UnexpectedToken.new(value.position) if !node.entries.empty? && !@comma
      @comma = false
      node.append value
    end

    def append(comma : Nodes::FlowComma)
      Yaml.debug "#{self.to_s.ljust(9)} a  (,):#{comma.position.line_and_column}"
      if @comma
        node.append Nodes::Null.new(comma.position)
      end
      @comma = true
    end

    def append(indicator : Nodes::FlowSequenceEnd)
      Yaml.debug "#{self.to_s.ljust(9)} a  (]):#{indicator.position.line_and_column}"
      if @comma
        node.append Nodes::Null.new(indicator.position)
      end
      @end = true
    end

    def outdent
      raise SequenceNotEnded.new(position) unless @end
    end

    def keyable?(pos)
      true
    end
  end
end
