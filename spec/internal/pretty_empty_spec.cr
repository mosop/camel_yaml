require "../spec_helper"

module YamlInternalOrderingFeature
  it name do
    yaml = Yaml.parse(<<-EOS
    a: {}
    b: []
    EOS
    )

    yaml.pretty.should eq <<-EOS
    ---
    a: {}
    b: []
    EOS
  end
end
