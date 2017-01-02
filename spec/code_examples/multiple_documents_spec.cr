require "../spec_helper"

module YamlCodeExamplesMultipleDocuments
  it name do
    yaml = Yaml.parse(<<-EOS
    smiley:
      face: :)
      greeting: hello
    ---
    smiley:
      face: :(
      greeting: bye
    EOS
    )
    yaml.documents[0].raw.should eq({"smiley" => {"face" => ":)", "greeting" => "hello"}})
    yaml.documents[1].raw.should eq({"smiley" => {"face" => ":(", "greeting" => "bye"}})
  end
end
