module Yaml::Nodes
  class Alias < Value
    getter alias_name : String

    def initialize(@alias_name, @position)
    end

    @anchor_value : Entity?
    def anchor_value
      @anchor_value ||= begin
        if v = document.anchors[alias_name]?
          v.anchor_value
        else
          raise AnchorNotDefined.new(position)
        end
      end
    end

    def accessible_entry?(index)
      anchor_value.accessible_entry?(index)
    end

    def accessible_mapping?
      anchor_value.accessible_mapping?
    end

    def accessible_sequence?
      anchor_value.accessible_sequence?
    end

    def accessible_key?
      anchor_value.accessible_key?
    end

    def accessible_keys?
      anchor_value.accessible_keys?
    end

    def each_accessible_key
      anchor_value.each_accessible_key do |key|
        yield key
      end
    end

    def new_builder(parent, index)
      anchor_value.new_builder(parent, index)
    end

    def raw
      anchor_value.raw
    end

    def raw_string?
      anchor_value.raw_string?
    end

    def raw_hash?
      anchor_value.raw_hash?
    end

    def raw_array?
      anchor_value.raw_array?
    end

    def to_string_mapping_key
      anchor_value.to_string_mapping_key
    end

    def put_pretty_key_for_single_line(io : IO, indent : String)
      io << indent
      io << "*"
      io << @alias_name
    end

    def put_pretty_key_for_multiline(io : IO, indent : String)
      io << indent
      io << "*"
      io << @alias_name
      io << ":"
      put_pretty_trailing_comment? io, " "
    end

    def put_pretty_value(io : IO, indent : String)
      io << indent
      io << "*"
      io << @alias_name
      put_pretty_trailing_comment? io, " "
    end
  end
end
