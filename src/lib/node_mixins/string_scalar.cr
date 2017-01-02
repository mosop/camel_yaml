module Yaml::NodeMixins
  module StringScalar
    property string : String

    def initialize(@string, @position)
    end

    def accessible_entry?(index)
    end

    def accessible_mapping?
    end

    def accessible_key?
    end

    def accessible_keys?
    end

    def each_accessible_key(&block : String -> _)
    end

    def fallback_entry(index)
      raise Bug_IllegalFallbackEntryCall.new(self.class.name)
    end

    def new_builder(parent, index)
      Builders::Scalar.new(parent, index, self)
    end

    def raw
      @string
    end

    def raw_string?
      raw
    end

    def raw_hash?
    end

    def raw_array?
    end

    def to_s(io : IO)
      put_pretty_string? io, ""
    end
  end
end
