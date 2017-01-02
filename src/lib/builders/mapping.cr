module Yaml::Builders
  class Mapping
    include Base

    @mapping : Nodes::Mapping

    def initialize(@parent, @index, @mapping : Nodes::Mapping)
    end

    def node
      @mapping
    end

    def [](index : Int32, key : String)
      MappingEntry.new(self, index, @mapping.accessible_entry?(index) || @mapping.fallback_entry(index, key))
    end

    def [](index : String)
      MappingEntry.new(self, index, @mapping.accessible_entry?(index) || @mapping.fallback_entry(index))
    end

    def comment=(s : String)
      assign_leading_comment_to s, @mapping
    end

    def trailing_comment=(s : String)
      assign_trailing_comment_to s, @mapping
    end

    def assign_child_value(child, index, s : String?)
      raise Bug_IllegalAssignChildValueCall.new(self.class.name)
    end
  end
end
