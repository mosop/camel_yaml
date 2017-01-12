require "../spec_helper"

module YamlInternalSpecPrettyEmpty
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
