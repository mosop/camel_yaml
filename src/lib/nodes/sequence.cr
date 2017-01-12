module Yaml::Nodes
  class Sequence < Entity
    include NodeMixins::Parent

    getter entries = [] of SequenceEntry

    def append(value : Nodes::Value)
      Yaml.debug "Seq:#{@position.line_and_column}".ljust(9) + " a  #{value} [#{"%x" % object_id}]"
      entry = SequenceEntry.new(self, value)
      @entries << entry
      entry
    end

    def append(raw : RawArg?)
      append(Yaml.to_node(position, raw))
    end

    def change(entry : SequenceEntry)
    end

    def accessible_entry?(index : Int32)
      entries[index]?
    end

    def accessible_entry?(index : String)
    end

    def accessible_mapping?
    end

    def accessible_key?
    end

    def accessible_keys?
    end

    def each_accessible_key(&block : String -> _)
    end

    def fallback_entry(index : Int32)
      while index < @entries.size
        append Null.new(position)
      end
      append Null.new(position)
    end

    def new_builder(parent, index)
      Builders::Sequence.new(parent, index, self)
    end

    def raw
      ([] of Raw).tap do |a|
        entries.each do |v|
          a << v.raw
        end
      end
    end

    def raw_string?
    end

    def raw_hash?
    end

    def raw_array?
      raw
    end

    def merge!(raw : RawArrayArg)
      raw.each do |i|
        self << Yaml.to_node(position, i)
      end
      self
    end

    def <<(value)
      append value
    end

    def put_pretty(io : IO, indent : String, first_indent : String? = nil)
      if put_pretty_leading_comment?(io, indent, first_indent: first_indent)
        put_pretty_entries io, indent, "\n#{indent}"
      else
        put_pretty_entries io, indent, first_indent
      end
    end

    def put_pretty_entries(io : IO, indent : String, first_indent : String? = nil)
      if @entries.empty?
        io << first_indent || indent
        "[]"
      else
        @entries.each.first(1).each do |entry|
          entry.put_pretty io, indent, first_indent
        end
        @entries.each.skip(1).each do |entry|
          entry.put_pretty io, indent, "\n#{indent}"
        end
      end
    end
  end
end
