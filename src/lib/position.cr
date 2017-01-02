module Yaml
  struct Position
    include Comparable(Position)

    getter source : Source
    getter line_and_column : LineAndColumn

    def initialize(@source, @line_and_column)
    end

    def initialize(source : Source, line : Int32, column : Int32)
      initialize source, LineAndColumn.new(line, column)
    end

    def initialize(source : Source)
      initialize source, 0, 0
    end

    def line
      @line_and_column.line
    end

    def column
      @line_and_column.column
    end

    def to_s(io : IO)
      io << "#{@source.location || "(unknown)"}:#{@line_and_column}"
    end

    def <=>(other : Position)
      line_and_column <=> other.line_and_column
    end

    def trails?(to : Position)
      line_and_column.trails?(to.line_and_column)
    end

    EMPTY_OR_SPACE_LINE = /^[ \t]*$/

    def trails_empty_or_space?
      column == 0 || EMPTY_OR_SPACE_LINE =~ @source.lines[line][0..column-1]
    end
  end
end
