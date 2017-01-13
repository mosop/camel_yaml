module Yaml
  alias Raw = Hash(String, Raw) | Array(Raw) | String | Nil
  alias Index = Int32 | String
  alias RawHash = Hash(String, Raw)
  alias RawArray = Array(Raw)
  alias RawHashArg = RawHash
  alias RawArrayArg = RawArray
  alias RawArg = Raw | RawHashArg | RawArrayArg

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
