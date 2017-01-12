module Yaml
  macro debug(s = nil, &block)
    {% if flag?(:debug) %}
      {% if s %}
        puts {{s}}
      {% elsif block %}
        {{block.body}}
      {% end %}
    {% end %}
  end

  def self.parse(text : String)
    Io::Memory.new(text).load
  end

  def self.parse_file(path : String)
    Io::File.new(path).load
  end

  def self.new_builder_position(location = nil)
    location ||= "(builder)"
    Position.new(Source.new(location), LineAndColumn.new(0, 0))
  end

  def self.new_builder_stream(location = nil)
    Nodes::Document.new(nil, new_builder_position(location)).to_stream
  end

  def self.map(location = nil)
    new_builder_stream(location).tap do |stream|
      doc = stream.document
      map = Nodes::Mapping.new(doc.position)
      doc.append map
      yield Builders::Mapping.new(nil, nil, map)
    end
  end

  def self.to_node(position, raw : RawHashArg)
    Nodes::Mapping.new(position).merge! raw
  end

  def self.to_node(position, raw : RawArrayArg)
    Nodes::Sequence.new(position).merge! raw
  end

  def self.to_node(position, raw : String?)
    Nodes::Scalar.new_string_scalar(raw, position)
  end
end
