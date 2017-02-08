require "../spec_helper"

module YamlInternalSpecCustomAccessorEach
  class Attr < Yaml::Accessor
    getter attr : String

    def initialize(@attr)
    end
  end

  class Attrs < Yaml::Accessor
    getter attr : String

    def initialize(@attr)
    end

    custom_map Attr, "@attr"
  end

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
