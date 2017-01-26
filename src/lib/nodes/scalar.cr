module Yaml::Nodes
  abstract class Scalar < Entity
    NULL_SCALAR = "!<tag:yaml.org,2002:null> ''"

    def put_pretty(io : IO, indent : String, first_indent : String = nil)
      put_pretty_value io, first_indent || indent
    end

    def put_pretty_key_for_single_line(io : IO, indent : String)
      indent = put_pretty_anchor?(io, indent) ? " " : indent
      if put_pretty_tag?(io, indent)
        io << " ''" unless put_pretty_string?(io, " ")
      elsif put_pretty_string?(io, indent)
      else
        io << indent
        io << NULL_SCALAR
      end
      io << ":"
    end

    def put_pretty_key_for_multiline(io : IO, indent : String)
      indent = put_pretty_anchor?(io, indent) ? " " : indent
      if put_pretty_tag?(io, indent)
        io << " ''" unless put_pretty_string?(io, " ")
        io << ":"
        yield
        put_pretty_trailing_comment? io, " "
      elsif put_pretty_string?(io, indent)
        io << ":"
        yield
        put_pretty_trailing_comment? io, " "
      else
        io << indent
        io << NULL_SCALAR
        io << ":"
        yield
        put_pretty_trailing_comment? io, " "
      end
    end

    def put_pretty_value(io : IO, indent : String)
      if put_pretty_anchor_and_tag?(io, indent)
        put_pretty_string? io, " "
        put_pretty_trailing_comment? io, " "
      elsif put_pretty_string?(io, indent)
        put_pretty_trailing_comment? io, " "
      else
        put_pretty_trailing_comment? io, indent
      end
    end

    def self.new_string_scalar(s : String?, pos)
      if s
        if s.empty? || s.includes?("'")
          SingleQuotedString.new(s, pos)
        else
          UnquotedString.new(s, pos)
        end
      else
        Null.new(pos)
      end
    end
  end
end
