require "../spec_helper"

module YamlCodeExamplesNumeralAccess
  it name do
    yaml = Yaml.parse(<<-EOS
    Yoshimi: Battles
    the: Pink Robots
    EOS
    )

    yaml[0].s.should eq "Battles"
    yaml[1].s.should eq "Pink Robots"
  end
end
