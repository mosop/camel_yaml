require "../spec_helper"

module YamlCodeExamplesNilableAccess
  describe name do
    it "1" do
      yaml = Yaml.parse(<<-EOS
      foo:
      EOS
      )

      yaml["bar"].s?.should be_nil
    end

    it "2" do
      yaml = Yaml.parse(<<-EOS
      cakes:
      - name: strawberry
      - name: cheese
      - name: chocolat
      EOS
      )

      yaml["cakes"][999]["name"].s?.should be_nil
    end
  end
end
