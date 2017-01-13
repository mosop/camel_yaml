module Yaml::NodeMixins
  module Null
    def accessible_entry?(index)
    end

    def accessible_mapping?
    end

    def accessible_sequence?
    end

    def accessible_key?
    end

    def accessible_keys?
    end

    def each_accessible_key(&block : String -> _)
    end

    def new_builder(parent, index)
      Builders::Scalar.new(parent, index, self)
    end

    def raw
    end

    def raw_string?
    end

    def raw_hash?
    end

    def raw_array?
    end

    def pretty?
    end

    def put_pretty_string?(io : IO, indent : String)
      false
    end
  end
end
