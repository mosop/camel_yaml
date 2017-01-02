module Yaml::Nodes
  class Tag
    include NodeMixins::Base
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment

    getter string : String

    def initialize(@string, @position)
    end
  end
end
