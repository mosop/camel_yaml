module Yaml::Nodes
  abstract class Entity < Value
    include NodeMixins::HasAnchor
    include NodeMixins::HasTag

    def parent=(value)
      super
      if anchor = @anchor
        document.anchors[anchor.anchor_name] = anchor
        anchor.anchor_value = self
      end
    end

    def to_string_mapping_key
      raw.to_s
    end

    def put_pretty_anchor_and_tag?(io : IO, indent : String)
      if put_pretty_anchor?(io, indent)
        put_pretty_tag? io, " "
        true
      else
        put_pretty_tag?(io, indent)
      end
    end
  end
end
