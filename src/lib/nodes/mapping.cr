module Yaml::Nodes
  class Mapping < Entity
    include NodeMixins::Parent

    getter entries = [] of MappingEntry

    @string_key_entries : Hash(String, MappingEntry)?
    def string_key_entries
      @string_key_entries ||= make_string_key_entries
    end

    def make_string_key_entries
      h = {} of String => MappingEntry
      @entries.each do |kv|
        sk = kv.key.to_string_mapping_key
        if sk == "<<"
          merge_string_key_entries_into(kv.key, kv.value, h)
        else
          h[sk] = kv
        end
      end
      h
    end

    def merge_string_key_entries_into(k, v : Mapping, h)
      v.string_key_entries.each do |k, v|
        h[k] = v
      end
    end

    def merge_string_key_entries_into(k, v : Sequence, h)
      v.entries.each do |v|
        merge_string_key_entries_into k, v.value, h
      end
    end

    def merge_string_key_entries_into(k, v : Alias, h)
      merge_string_key_entries_into k, v.anchor_value, h
    end

    def merge_string_key_entries_into(k, v : Scalar | Null | Undefined, h)
      h["<<"] = MappingEntry.new(self, k, v)
    end

    def append(key : Value, value : Value)
      Yaml.debug "Map:#{@position.line_and_column}".ljust(9) + " a  #{key} => #{value} [#{"%x" % object_id}]"
      change_entry
      entry = MappingEntry.new(self, key, value)
      @entries << entry
      entry
    end

    def change_entry
      @string_key_entries = nil
    end

    def change(entry : MappingEntry)
      change_entry
    end

    def accessible_entry?(index : Int32)
      entries[index]?
    end

    def accessible_entry?(index : String)
      string_key_entries[index]?
    end

    def accessible_mapping?
      self
    end

    def accessible_key?
    end

    def accessible_keys?
      string_key_entries.keys
    end

    def each_accessible_key
      string_key_entries.dup.each_key do |key|
        yield key
      end
    end

    def fallback_entry(index : Int32, key : String)
      while index < @entries.size
        append Null.new(position), Null.new(position)
      end
      append UnquotedString.new(key, position), Null.new(position)
    end

    def fallback_entry(index : String)
      append Scalar.new_string_scalar(index, position), Null.new(position)
    end

    def new_builder(parent, index)
      Builders::Mapping.new(parent, index, self)
    end

    def build
      yield Builders::Mapping.new(nil, nil, self)
    end

    def raw
      ({} of String => Raw).tap do |h|
        entries.each do |kv|
          sk = kv.key.to_string_mapping_key
          if sk == "<<"
            merge_into_raw_hash kv.value, h
          else
            h[sk] = kv.value.raw
          end
        end
      end
    end

    def raw_string?
    end

    def raw_hash?
      raw
    end

    def raw_array?
    end

    def merge_into_raw_hash(v : Mapping, h)
      v.raw.each do |k, v|
        h[k] = v
      end
    end

    def merge_into_raw_hash(v : Sequence, h)
      v.entries.each do |v|
        merge_into_raw_hash v.value, h
      end
    end

    def merge_into_raw_hash(v : Alias, h)
      merge_into_raw_hash v.anchor_value, h
    end

    def merge_into_raw_hash(v : Scalar | Null | Undefined, h)
      h["<<"] = v.raw
    end

    def put_pretty(io : IO, indent : String, first_indent : String? = nil)
      if put_pretty_leading_comment?(io, indent, first_indent)
        put_pretty_entries io, indent, "\n#{indent}"
      else
        put_pretty_entries io, indent, first_indent
      end
    end

    def put_pretty_entries(io : IO, indent : String, first_indent : String? = nil)
      if @entries.empty?
        io << first_indent || indent
        "{}"
      else
        @entries.each.first(1).each do |entry|
          entry.put_pretty io, indent, first_indent
        end
        @entries.each.skip(1).each do |entry|
          entry.put_pretty io, indent, "\n#{indent}"
        end
      end
    end

    def collect_key_paths(path : Array(String) = %w(), a : Array(Array(String)) = [] of Array(String))
      string_key_entries.each do |key, entry|
        new_path = path.dup + [key]
        case v = entry.value
        when Mapping
          v.collect_key_paths new_path, a
        else
          a << new_path
        end
      end
      a
    end

    def []=(key : String, value : String?)
      if entry = string_key_entries[key]?
        entry.value = Scalar.new_string_scalar(value, position)
        entry.change
      else
        append Scalar.new_string_scalar(key, position), Scalar.new_string_scalar(value, position)
      end
    end
  end
end
