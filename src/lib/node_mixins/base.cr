module Yaml::NodeMixins
  module Base
    include NodeMixins::HasPosition

    def initialize(@position)
    end

    def append_node(node : Nil)
    end
  end
end
