module Yaml::Nodes
  class Anchor
    include NodeMixins::Base
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment

    getter anchor_name : String
    property! anchor_value : Entity?

    def initialize(@anchor_name, @position)
    end
  end
end
