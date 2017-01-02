require "../spec_helper"

module YamlCodeExamplesNilableAccess
  it name do
    yaml = Yaml.parse(<<-EOS
    Yoshimi: Battles
    the: Pink Robots
    EOS
    )

    yaml[0].key.should eq "Yoshimi"
    yaml[1].key.should eq "the"
  end
end
