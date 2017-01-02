module Yaml::Nodes
  abstract struct Comment
    include NodeMixins::HasPosition

    getter string : String

    def initialize(@string, @position)
    end
  end
end
