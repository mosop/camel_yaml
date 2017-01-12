require "../spec_helper"

module YamlInternalSpecAccessorFallback
  it name do
    yaml = Yaml.parse("")
    yaml["foo"]["bar"]["baz"] = "value"
    yaml.pretty.should eq <<-EOS
    ---
    foo:
      bar:
        baz: value
    EOS
  end
end
