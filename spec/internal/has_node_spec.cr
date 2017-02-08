require "../spec_helper"

module YamlInternalSpecs::HasNode
  describe name do
    it "true" do
      yaml = Yaml.parse(<<-EOS
      foo:
        bar:
      EOS
      )
      yaml["foo"].has_node?.should be_true
    end

    it "false" do
      yaml = Yaml.parse(<<-EOS
      foo:
      EOS
      )
      yaml["foo"].has_node?.should be_false
    end
  end
end
