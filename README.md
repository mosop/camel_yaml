# Yaml (Camel YAML)

A yet another Crystal library for parsing and writing YAML documents.

Yaml does/is:

* parses comments to write them back
* integrates your own document schema to easily access typed contents
* a pure Crystal implementation not requiring libyaml or another library.

Also, Yaml is not fully compatible with the standard YAML for simplicity.

This project is experimental.

[![Build Status](https://travis-ci.org/mosop/camel_yaml.svg?branch=master)](https://travis-ci.org/mosop/camel_yaml)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  camel_yaml:
    github: mosop/camel_yaml
```

<a name="code_examples"></a>
## Code Examples

### Basic

```crystal
yaml = Yaml.parse(<<-EOS
smilies:
  :): hello
  :(: bye
EOS
)

yaml.raw
# => {":)" => "hello", ":(" => "bye"}
```

### Multiple Documents

```crystal
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

yaml.documents[0].raw
# => {"smiley" => {"face" => ":)", "greeting" => "hello"}}
yaml.documents[1].raw
# => {"smiley" => {"face" => ":(", "greeting" => "bye"}}
```

### Accessor

```crystal
yaml = Yaml.parse(<<-EOS
ducks:
- name: huey
- name: dewey
- name: louie
EOS
)

yaml["ducks"].a
# => [{"name" => "huey"}, {"name" => "dewey"}, {"name" => "louie"}]
yaml["ducks"][0].h
# => {"name" => "huey"}
yaml["ducks"][0]["name"].s
# => "huey"
```

### Numeral Access

```crystal
yaml = Yaml.parse(<<-EOS
Yoshimi: Battles
the: Pink Robots
EOS
)

yaml[0].s # => "Battles"
yaml[1].s # => "Pink Robots"
```

### Accessing Keys

```crystal
yaml = Yaml.parse(<<-EOS
Yoshimi: Battles
the: Pink Robots
EOS
)

yaml[0].key # => "Yoshimi"
yaml[1].key # => "the"
```

### Nilable Access

```crystal
yaml = Yaml.parse(<<-EOS
foo:
EOS
)

yaml["bar"].s? # => nil
```

```crystal
yaml = Yaml.parse(<<-EOS
cakes:
- name: strawberry
- name: cheese
- name: chocolat
EOS
)

yaml["cakes"][999]["name"].s? # => nil
```

### Building

```crystal
doc = Yaml.map do |map|
  map["faces"].seq do |seq|
    seq.comment = <<-EOS
     add smiley icons below
     one face a row
    EOS
    seq.s ":)"
    seq.s ":("
    seq.s ":P"
  end
end

puts doc.pretty

doc["faces"][0].build do |s|
  s.value = ";)"
  s.trailing_comment = " wink!"
end

puts doc.pretty
```

Output:

```
---
faces:
# add smiley icons below
# one face a row
- :)
- :(
- :P
---
faces:
# add smiley icons below
# one face a row
- ;) # wink!
- :(
- :P
```

### Custom Accessor

```crystal
class Site < Yaml::Accessor
  def name
    s
  end

  def url
    "http://mosop.#{s}"
  end
end

class Sites < Yaml::Accessor
  custom_seq Site
end

yaml = Yaml.parse(<<-EOS
- rocks
- yoga
- ninja
EOS
)

yaml[Sites][0].name # => "rocks"
yaml[Sites][0].url # => "http://mosop.rocks"
```

## Layering

```crystal
layer = Yaml.parse(<<-EOS
:): hello
EOS
).new_layer

layer.next_layer = Yaml.parse(<<-EOS
:(: bye
EOS
).new_layer

layer[":)"].s => # hello
layer[":("].s => # bye
```

## Usage

```crystal
require "camel_yaml"
```

and see [Code Examples](#code_examples) and [Wiki](https://github.com/mosop/camel_yaml/wiki).

<!--
## Contributing

### Contribute Your Example YAML

1. Fork it ( https://github.com/mosop/camel_yaml/fork )
2. Create your feature branch (git checkout -b your-new-feature)
3. Add your example spec (a *_spec.cr file) into the spec/our_examples directory
4. Push to the branch (git push origin your-new-feature)
5. Create a new Pull Request
-->
