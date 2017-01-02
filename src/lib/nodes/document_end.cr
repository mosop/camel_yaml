module Yaml::Nodes
  class DocumentEnd
    include NodeMixins::Base
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment
  end
end
