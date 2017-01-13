require "../spec_helper"

module YamlInternalSpecSetter
  it name do
    yaml = Yaml.parse("")
    yaml["s"] = "value"
    yaml["h"] = Yaml::RawHash.new
    yaml["a"] = Yaml::RawArray.new
    yaml["null"] = nil

    yaml.pretty.should eq <<-EOS
    ---
    s: value
    h: {}
    a: []
    null:
    EOS
  end
end
