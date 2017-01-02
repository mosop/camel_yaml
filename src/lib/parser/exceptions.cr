module Yaml
  class Parser
    class StartDocument < Exception
      getter? node : Nodes::DocumentStart?

      def initialize(@node)
      end
    end

    class Eos < Exception
    end
  end
end
