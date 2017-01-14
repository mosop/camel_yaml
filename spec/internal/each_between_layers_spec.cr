require "../spec_helper"

module YamlInternalSpecEachBetweenLayers
  it name do
    layer = Yaml.parse(<<-EOS
    foo: 1
    baz: 1
    EOS
    ).new_layer

    layer.next_layer = Yaml.parse(<<-EOS
    bar: 2
    baz: 2
    EOS
    ).new_layer

    a = %w()

    layer.each do |i|
      a << i.key
      a << i.s
    end

    a.should eq %w(foo 1 baz 1 bar 2)
  end
end
