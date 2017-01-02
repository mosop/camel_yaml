module Yaml::ListEntries
  module Mapping
    getter? key : Nodes::Value?
    @value : Nodes::Value?

    def append_to(l)
      key = @key || Nodes::Null.new(@position)
      value = @value || Nodes::Null.new(@position)
      l.append key, value
    end

    def key=(value : Nodes::Value?)
      @key = value
      if value
        apply_to value
      end
    end

    def value=(value : Nodes::Value)
      @value = value
      apply_to value
    end
  end
end
