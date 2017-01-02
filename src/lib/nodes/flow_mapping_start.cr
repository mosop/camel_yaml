module Yaml::Nodes
  class FlowMappingStart
    include NodeMixins::Base
    include NodeMixins::HasAnchor
    include NodeMixins::HasTag
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment
  end
end
