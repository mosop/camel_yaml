module Yaml::Nodes
  class DocumentStart
    include NodeMixins::Base
    include NodeMixins::HasAnchor
    include NodeMixins::HasTag
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment
  end
end
