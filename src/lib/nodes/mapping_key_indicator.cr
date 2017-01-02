module Yaml::Nodes
  class MappingKeyIndicator
    include NodeMixins::Base
    include NodeMixins::HasTag
    include NodeMixins::HasAnchor
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment
  end
end
