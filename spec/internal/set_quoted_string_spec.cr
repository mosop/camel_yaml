require "../spec_helper"

module YamlInternalSetQuotedString
  it name do
    yaml = Yaml.parse("")
    yaml["foo"].quote = "test"
    yaml.pretty.should eq <<-EOS
    ---
    foo: "test"
    EOS
  end
end
