module Yaml
  class Source
    getter location : String
    getter lines = [] of String
    getter hard_lines = [] of String?
    getter line_indexes = [] of Int32

    def initialize(@location)
    end

    # def position(target : HasPosition, lnc : LineAndColumn)
    #   positions[target.object_id] = Position.new
    # end
    #
    # def position(target : HasPosition)
    #   positions[taget.object_id]? || Position.new(self, LineAndColumn.new(0, 0))
    # end
  end
end
