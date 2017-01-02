module Yaml::Nodes
  class DoubleQuotedString < Scalar
    include NodeMixins::StringScalar

    def put_pretty_string?(io : IO, indent : String)
      io << indent
      io << "\""
      IO::Memory.new(@string).each_char do |char|
        io << (case char
        when '\u{0}'
          "\\0"
        when '\u{7}'
          "\\a"
        when '\u{8}'
          "\\b"
        when '\u{9}'
          "\\t"
        when '\u{7}'
          "\\a"
        when '\u{a}'
          "\\n"
        when '\u{b}'
          "\\v"
        when '\u{c}'
          "\\f"
        when '\u{d}'
          "\\r"
        when '\u{1b}'
          "\\e"
        when '"'
          "\\\""
        when '\\'
          "\\\\"
        when '\u{85}'
          "\\N"
        when '\u{a0}'
          "\\_"
        when '\u{2028}'
          "\\L"
        when '\u{2029}'
          "\\P"
        else
          char
        end)
      end
      io << "\""
      true
    end
  end
end
