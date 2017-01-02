module Yaml::NodeMixins
  module HasPosition
    getter position : Position

    def indent
      @position.column
    end

    def trails?(to : HasPosition)
      @position.trails?(to.position)
    end

    def trails_empty_or_space?
      @position.trails_empty_or_space?
    end
  end
end
