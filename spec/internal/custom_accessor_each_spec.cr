require "../spec_helper"

module YamlInternalSpecCustomAccessorEach
  class Attr
    include Yaml::Schema

    class Accessor
      getter attr : String

      def initialize(@attr)
      end
    end
  end
  Attr.register_schema

  class Attrs
    include Yaml::Schema

    class Accessor
      getter attr : String

      def initialize(@attr)
      end
    end

    map Attr, "@attr"
  end
  Attrs.register_schema

  it name do
    yaml = Yaml.parse(<<-EOS
    attr1:
    attr2:
    EOS
    )

    yaml[Attrs, "attr"].each do |i|
      i.attr.should eq "attr"
    end
  end
end
