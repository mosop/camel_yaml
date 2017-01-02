module Yaml::ListEntryContainers
  class BlockMapping < Base
    def __type
      "MAP"
    end

    @entries = [] of ListEntries::BlockMapping
    @key : ListEntries::BlockMappingKey?
    @value : ListEntries::BlockMappingValue?

    @node : Nodes::Mapping?
    def node
      @node ||= Nodes::Mapping.new(@position)
    end

    def flow?
    end

    def indents?(entry : ListEntries::BlockMapping)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry} -- #{indent < entry.indent}"
      indent < entry.indent
    end

    def indents?(entry : ListEntries::BlockMappingKey)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry} -- #{indent < entry.indent}"
      indent < entry.indent
    end

    def indents?(entry : ListEntries::BlockMappingValue)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry} -- #{indent < entry.indent}"
      indent < entry.indent
    end

    def indents?(entry : ListEntries::BlockSequence)
      Yaml.debug "#{self.to_s.ljust(9)} i? #{entry} -- #{indent <= entry.indent}"
      indent <= entry.indent
    end

    def appends?(entry : ListEntries::BlockMapping)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry} -- #{indent == entry.indent}"
      indent == entry.indent
    end

    def appends?(entry : ListEntries::BlockMappingKey)
      Yaml.debug "#{self.to_s.ljust(9)} a? #{entry} -- #{indent == entry.indent}"
      indent == entry.indent
    end

    def appends?(entry : ListEntries::BlockMappingValue)
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

    def append(entry : ListEntries::BlockMapping)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      outdent_key_and_value
      @entries << entry
    end

    def append(entry : ListEntries::BlockMappingKey)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      outdent_key_and_value
      @key = entry
    end

    def append(entry : ListEntries::BlockMappingValue)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{entry}"
      if key = @key
        entry.key = key.key?
        @value = entry
      else
        raise KeyNotDefined.new(entry.position)
      end
    end

    def append(value : Nodes::Value)
      Yaml.debug "#{self.to_s.ljust(9)} a  #{value}"
      if entry = @value
        entry.value = value
        entry.append_to node
        @key = nil
        @value = nil
      elsif entry = @key
        entry.key = value
      else
        raise UnexpectedToken.new(value.position) if @entries.empty?
        entry = @entries.pop
        outdent
        entry.value = value
        entry.append_to node
      end
    end

    def outdent
      outdent_key_and_value
      while entry = @entries.shift?
        entry.append_to node
      end
    end

    def outdent_key_and_value
      if entry = @value || @key
        entry.append_to node
      end
    end

    def keyable?(pos)
      @entries.empty?
    end
  end
end
