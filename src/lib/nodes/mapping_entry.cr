module Yaml::Nodes
  class MappingEntry
    include NodeMixins::Parent
    include NodeMixins::HasParent
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment

    getter key : Value
    getter value : Value

    def initialize(@parent : Mapping, key : Value, value : Value)
      @key = key
      @value = value
      key.parent = @parent
      value.parent = @parent
    end

    def position
      @key.position
    end

    def mapping
      parent.as(Mapping)
    end

    def key=(value : Value)
      value.parent = self
      @key = value
      mapping.update_index self
      value
    end

    def value=(value : Value)
      value.parent = @parent
      @value = value
      mapping.update_value self
      value
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
      @key.to_string_mapping_key
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
      Builders::MappingEntry.new(parent, index, self)
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
      case k = @key
      when Scalar, Alias
        put_pretty_simple_key_mapping_entry(k, io, indent, first_indent: first_indent)
      else
        put_pretty_complex_key_mapping_entry(k, io, indent, first_indent: first_indent)
      end
    end

    def put_pretty_simple_key_mapping_entry(k, io, indent, first_indent : String? = nil)
      case v = @value
      when Scalar, Alias
        k.put_pretty_key_for_single_line io, first_indent || indent
        v.put_pretty_value io, " "
      else
        case v
        when Mapping
          if v.entries.empty?
            k.put_pretty_key_for_single_line io, first_indent || indent
            io << " {}"
          else
            k.put_pretty_key_for_multiline io, first_indent || indent do
              v.put_pretty_anchor? io, " "
            end
            v.put_pretty io, "#{indent}  ", "\n#{indent}  "
          end
        when Sequence
          if v.entries.empty?
            k.put_pretty_key_for_single_line io, first_indent || indent
            io << " []"
          else
            k.put_pretty_key_for_multiline io, first_indent || indent do
              v.put_pretty_anchor? io, " "
            end
            v.put_pretty io, indent, "\n#{indent}"
          end
        end
      end
    end

    def put_pretty_complex_key_mapping_entry(k, io, indent, first_indent)
      raise Bug_NotImplemented.new("#{self.class.name}#put_pretty_complex_key_mapping_entry")
    end
  end
end
