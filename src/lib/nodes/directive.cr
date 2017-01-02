module Yaml::Nodes
  abstract class Directive
    include NodeMixins::Base
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment

    getter string : String

    def initialize(@string, @position)
    end
  end
end
