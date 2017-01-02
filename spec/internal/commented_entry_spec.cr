require "../spec_helper"

module YamlInternalCommentedEntryFeature
  it name do
    yaml = Yaml.parse(<<-EOS
    a: foo #comment
    b: bar
    EOS
    )

    yaml["a"].s.should eq "foo"
  end
end
