require "../spec_helper"

module YamlCodeExamplesLayering
  it name do
    layer = Yaml.parse(<<-EOS
    :): hello
    EOS
    ).new_layer

    layer.next_layer = Yaml.parse(<<-EOS
    :(: bye
    EOS
    ).new_layer

    layer[":)"].s.should eq "hello"
    layer[":("].s.should eq "bye"
  end
end
