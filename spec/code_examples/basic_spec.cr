require "../spec_helper"

module YamlCodeExamplesBasic
  it name do
    yaml = Yaml.parse(<<-EOS
    smilies:
      :): hello
      :(: bye
    EOS
    )
    yaml.raw.should eq({"smilies" => {":)" => "hello", ":(" => "bye"}})
  end
end
