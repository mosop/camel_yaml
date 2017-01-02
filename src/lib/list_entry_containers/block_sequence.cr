module Yaml::ListEntryContainers
  class BlockSequence < Base
    def __type
      "SEQ"
    end

    @entries = [] of ListEntries::BlockSequence

    @node : Nodes::Sequence?
    def node
      @node ||= Nodes::Sequence.new(@position)
    end

    def flow?
    end

    def indents?(entry : ListEntries::BlockMapping)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry} -- #{indent < entry.indent}"
      indent < entry.indent
    end

    def indents?(entry : ListEntries::BlockSequence)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry} -- #{indent < entry.indent}"
      indent < entry.indent
    end

    def appends?(entry : ListEntries::BlockMapping)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry} -- #{indent == entry.indent}"
      indent == entry.indent
    end

    def appends?(entry : ListEntries::BlockSequence)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry} -- #{indent == entry.indent}"
      indent == entry.indent
    end

    def appends?(value : Nodes::Value)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{value} -- #{indent < value.indent}"
      indent < value.indent
    end

    def append(entry : ListEntries::BlockSequence)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      @entries << entry
    end

    def append(value : Nodes::Value)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{value}"
      raise UnexpectedToken.new(value.position) if @entries.empty?
      entry = @entries.pop
      outdent
      append entry, value
    end

    def append(entry : ListEntries::BlockSequence, value : Nodes::Value?)
      value ||= Nodes::Null.new(entry.position)
      apply_entry_to entry, value
      node.append value
    end

    def outdent
      while entry = @entries.shift?
        append entry, nil
      end
    end

    def keyable?(pos)
      true
    end
  end
end
