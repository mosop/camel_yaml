require "../spec_helper"

module YamlInternalSpecPrintAnchor
  it name do
    text = <<-EOS
    ---
    foo: &ref1
      bar: baz
    <<: *ref1
    qux:
    - &ref2
      foo:
        bar: baz
    - *ref2
    EOS
    Yaml.parse(text).pretty.should eq text
  end
end
