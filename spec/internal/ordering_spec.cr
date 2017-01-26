require "../spec_helper"

module YamlInternalOrderingFeature
  it name do
    yaml = Yaml.parse(<<-EOS
    a: #comment
    b:
    EOS
    )

    yaml.map.string_index_entries.keys.should eq ["a", "b"]
  end
end
