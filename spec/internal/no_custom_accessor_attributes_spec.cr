require "../spec_helper"

module YamlInternalSpecNoCustomAccessorAttributes
  class Attr < Yaml::Accessor
    def attr
      "attr"
    end
  end

  class Attrs < Yaml::Accessor
    custom_map Attr
  end

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
