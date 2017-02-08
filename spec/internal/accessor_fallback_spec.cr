require "../spec_helper"

module YamlInternalSpecAccessorFallback
  describe name do
    it "[]=" do
      yaml = Yaml.parse("")
      yaml["foo"]["bar"]["baz"] = "value"
      yaml.pretty.should eq <<-EOS
      ---
      foo:
        bar:
          baz: value
      EOS
    end

    it "value=" do
      yaml = Yaml.parse("")
      yaml["foo"]["bar"]["baz"].value = "value"
      yaml.pretty.should eq <<-EOS
      ---
      foo:
        bar:
          baz: value
      EOS
    end
  end
end
