require "../spec_helper"

module YamlCodeExamplesAccessor
  it name do
    yaml = Yaml.parse(<<-EOS
    ducks:
    - name: huey
    - name: dewey
    - name: louie
    EOS
    )

    yaml["ducks"].a.should eq([{"name" => "huey"}, {"name" => "dewey"}, {"name" => "louie"}])
    yaml["ducks"][0].h.should eq({"name" => "huey"})
    yaml["ducks"][0]["name"].s.should eq("huey")
  end
end
