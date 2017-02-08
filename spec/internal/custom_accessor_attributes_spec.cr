require "../spec_helper"

module YamlInternalSpecCustomAccessorAttributes
  class Attr < Yaml::Accessor
    getter attr : String

    def initialize(@attr)
    end
  end

  it name do
    yaml = Yaml.parse(<<-EOS
    data
    EOS
    )

    yaml[Attr, "attr"].attr.should eq "attr"
  end
end
