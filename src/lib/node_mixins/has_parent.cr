module Yaml::NodeMixins
  module HasParent
    property? parent : Parent?

    def parent
      @parent.as(Parent)
    end

    def document
      parent.as(Parent).document
    end
  end
end
