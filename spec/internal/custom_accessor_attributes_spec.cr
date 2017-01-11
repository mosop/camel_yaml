require "../spec_helper"

module YamlInternalSpecCustomAccessorAttributes
  class Attr
    include Yaml::Schema

    class Accessor
      getter attr : String

      def initialize(@attr)
      end
    end
  end

  Attr.register_schema

  it name do
    yaml = Yaml.parse(<<-EOS
    data
    EOS
    )

    yaml[Attr, "attr"].attr.should eq "attr"
  end
end
