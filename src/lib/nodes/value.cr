module Yaml::Nodes
  abstract class Value
    include NodeMixins::Base
    include NodeMixins::HasParent
    include NodeMixins::HasLeadingComment
    include NodeMixins::HasTrailingComment

    def accessible_entry?(index : Int32)
      nil
    end

    def value=(value)
      parent.replace_child self, value
    end
  end
end
