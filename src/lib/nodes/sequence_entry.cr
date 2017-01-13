module Yaml::Nodes
  class SequenceEntry
    include NodeMixins::HasParent
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment

    getter value : Value

    def initialize(@parent : Sequence, value : Value)
      @value = value
      value.parent = @parent
    end

    def sequence
      parent.as(Sequence)
    end

    def change
      sequence.change self
    end

    def value=(value : Value)
      value.parent = @parent
      @value = value
    end

    def accessible_entry?(index : Int32 | String)
      @value.accessible_entry?(index)
    end

    def accessible_mapping?
      @value.accessible_mapping?
    end

    def accessible_sequence?
      @value.accessible_sequence?
    end

    def accessible_key?
      @value.accessible_key?
    end

    def accessible_keys?
      @value.accessible_keys?
    end

    def each_accessible_key
      @value.each_accessible_key do |key|
        yield key
      end
    end

    def fallback_entry(index)
      raise Bug_IllegalFallbackEntryCall.new(self.class.name)
    end

    def new_builder(parent, index)
      Builders::SequenceEntry.new(parent, index, self)
    end

    def raw
      @value.raw
    end

    def raw_string?
      @value.raw_string?
    end

    def raw_hash?
      @value.raw_hash?
    end

    def raw_array?
      @value.raw_array?
    end

    def put_pretty(io : IO, indent : String, first_indent : String? = nil)
      io << first_indent || indent
      io << "-"
      case v = @value
      when Scalar, Alias
        v.put_pretty_value io, " "
      when Mapping
        v.put_pretty io, indent + "  ", " "
      when Sequence
        v.put_pretty io, indent + "  "
      end
    end
  end
end
