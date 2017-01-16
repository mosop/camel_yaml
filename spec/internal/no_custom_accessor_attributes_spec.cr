require "../spec_helper"

module YamlInternalSpecNoCustomAccessorAttributes
  class Attr
    include Yaml::Schema

    class Accessor
      def attr
        "attr"
      end
    end
  end
  Attr.register_schema

  class Attrs
    include Yaml::Schema

    map Attr
  end
  Attrs.register_schema

  it name do
    yaml = Yaml.parse(<<-EOS
    attr1:
    attr2:
    EOS
    )

    yaml[Attrs].each do |i|
      i.attr.should eq "attr"
    end
  end
end
