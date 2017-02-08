require "../spec_helper"

module YamlCodeExamplesCustomAccessor
  class Site < Yaml::Accessor
    def name
      s
    end

    def url
      "http://mosop.#{s}"
    end
  end

  class Sites < Yaml::Accessor
    custom_seq Site
  end

  it name do
    yaml = Yaml.parse(<<-EOS
    - rocks
    - yoga
    - ninja
    EOS
    )

    yaml[Sites][0].name.should eq "rocks"
    yaml[Sites][0].url.should eq "http://mosop.rocks"
  end
end
