module Yaml::Nodes
  class FlowSequenceStart
    include NodeMixins::Base
    include NodeMixins::HasAnchor
    include NodeMixins::HasTag
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment
  end
end
