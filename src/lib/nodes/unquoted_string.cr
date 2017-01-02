module Yaml::Nodes
  class UnquotedString < Scalar
    include NodeMixins::StringScalar

    def put_pretty_string?(io : IO, indent : String)
      io << indent
      io << @string
      true
    end
  end
end
