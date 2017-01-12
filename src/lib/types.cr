module Yaml
  alias Raw = Hash(String, Raw) | Array(Raw) | String | Nil
  alias Index = Int32 | String
  alias RawHash = Hash(String, Raw)
  alias RawArray = Array(Raw)
  alias RawHashArg = RawHash
  alias RawArrayArg = RawArray
  alias RawArg = Raw | RawHashArg | RawArrayArg
end
