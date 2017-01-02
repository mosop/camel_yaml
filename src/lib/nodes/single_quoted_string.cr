module Yaml::Nodes
  class SingleQuotedString < Scalar
    include NodeMixins::StringScalar

    def put_pretty_string?(io : IO, indent : String)
      io << indent
      io << "'"
      io << @string.gsub("'", "''")
      io << "'"
      true
    end
  end
end
