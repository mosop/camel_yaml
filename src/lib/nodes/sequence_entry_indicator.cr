module Yaml::Nodes
  class SequenceEntryIndicator
    include NodeMixins::Base
    include NodeMixins::HasTag
    include NodeMixins::HasAnchor
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment
  end
end
