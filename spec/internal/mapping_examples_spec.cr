require "../spec_helper"

module YamlInternalMappingExamplesFeature
  @@number = 0

  macro expect(source, expected, file = __FILE__, line = __LINE__)
    Yaml.debug "\n" + "=" * 3
    it "({{file.id}}:{{line.id}})" do
      %src = {{source}}
      %expected = {{expected}}
      Yaml.parse(%src).raw.should eq(%expected)
    end
  end

  describe name do
    expect (<<-EOS
    a:
      b: foo
      c: bar
    EOS
    ), {"a" => {"b" => "foo", "c" => "bar"}}

    expect (<<-EOS
    "a":
      "b": "foo"
      "c": "bar"
    EOS
    ), {"a" => {"b" => "foo", "c" => "bar"}}

    expect (<<-EOS
    a:
      - foo
      - bar
    EOS
    ), {"a" => ["foo", "bar"]}

    expect (<<-EOS
    a:
    - foo
    - bar
    EOS
    ), {"a" => ["foo", "bar"]}

    expect (<<-EOS
    {
      a: {
        "b": foo,
        "c": bar
      }
    }
    EOS
    ), {"a" => {"b" => "foo", "c" => "bar"}}

    expect (<<-EOS
    {
      a: [
        foo,
        bar
      ]
    }
    EOS
    ), {"a" => ["foo", "bar"]}

    expect (<<-EOS
    {a: b}
    EOS
    ), {"a" => "b"}

    expect (<<-EOS
    foo: &foo
      foo
    bar: &bar
      bar
    a:
      b: *foo
      c: *bar
    EOS
    ), {"foo" => "foo", "bar" => "bar", "a" => {"b" => "foo", "c" => "bar"}}

    expect (<<-EOS
    data: &data
      b: foo
      c: bar
    a:
      <<: *data
    EOS
    ), {"data" => {"b" => "foo", "c" => "bar"}, "a" => {"b" => "foo", "c" => "bar"}}

    expect (<<-EOS
    data:
      - &data
        b: foo
        c: bar
    a:
      <<: *data
    EOS
    ), {"data" => [{"b" => "foo", "c" => "bar"}], "a" => {"b" => "foo", "c" => "bar"}}

    expect (<<-EOS
    a:
    EOS
    ), {"a" => nil}

    expect (<<-EOS
    a:
      b:
    EOS
    ), {"a" => {"b" => nil}}

    expect (<<-EOS
    a:
      b:
    c:
    EOS
    ), {"a" => {"b" => nil}, "c" => nil}

    expect (<<-EOS
    a:
      -
    EOS
    ), {"a" => [nil]}

    expect (<<-EOS
    a:
      -
        -
    EOS
    ), {"a" => [[nil]]}

    expect (<<-EOS
    a:
      -
        -
      -
    EOS
    ), {"a" => [[nil], nil]}

    expect (<<-EOS
    a:
      - b: foo
        c: bar
    EOS
    ), {"a" => [{"b" => "foo", "c" => "bar"}]}

    expect (<<-EOS
    ? a
    : foo
    EOS
    ), {"a" => "foo"}

    (h = {({"a" => {"b" => "c", "d" => "e"}}.to_s) => {"f" => {"g" => "h", "i" => "j"}}})
    expect (<<-EOS
    ? a:
        b: c
        d: e
    : f:
        g: h
        i: j
    EOS
    ), h

    expect (<<-EOS
    a: f o o
    EOS
    ), {"a" => "f o o"}

    expect (<<-EOS
    a:
      b:
        c:
    EOS
    ), {"a" => {"b" => {"c" => nil}}}

    expect (<<-EOS
    ?
    EOS
    ), {"" => nil}

    expect (<<-EOS
    a: b: c
    EOS
    ), {"a" => "b: c"}

    expect (<<-EOS
    a: b: c: d
    EOS
    ), {"a" => "b: c: d"}

    (h = {({"a" => "b: c"}.to_s) => nil})
    expect (<<-EOS
    ? a: b: c
    EOS
    ), h

    expect (<<-EOS
    ?
    : a: b: c
    EOS
    ), {"" => {"a" => "b: c"}}

    expect (<<-EOS
    - a: b: c
    EOS
    ), [{"a" => "b: c"}]
  end
end
