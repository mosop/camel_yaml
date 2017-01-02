module Yaml
  struct LineAndColumn
    include Comparable(LineAndColumn)

    getter line : Int32
    getter column : Int32

    def initialize(@line, @column)
    end

    def to_tuple
      {@line, @column}
    end

    def to_s(io : IO)
      io << "#{@line + 1}:#{@column + 1}"
    end

    def <=>(other : LineAndColumn)
      l = line <=> other.line
      l == 0 ? column <=> other.column : l
    end

    def trails?(to : LineAndColumn)
      @line == to.line
    end
  end
end
