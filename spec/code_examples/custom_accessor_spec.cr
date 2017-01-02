require "../spec_helper"

module YamlCodeExamplesCustomAccessor
  class Site
    include Yaml::Schema

    class Accessor
      def name
        s
      end

      def url
        "http://mosop.#{s}"
      end
    end
  end

  class Sites
    include Yaml::Schema

    seq Site
  end

  Sites.register_schema

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
