module Yaml::Nodes
  class MappingValueIndicator
    include NodeMixins::Base
    include NodeMixins::HasTag
    include NodeMixins::HasAnchor
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment
  end
end
