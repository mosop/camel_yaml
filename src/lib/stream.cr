module Yaml
  class Stream
    getter location : String
    getter documents = [] of Nodes::Document

    def initialize(@location)
    end

    def [](index : Index)
      new_accessor[index]
    end

    def new_accessor
      Accessor.new(new_layer, 0, @documents[0].value)
    end

    def new_layer(*args)
      Layer.new(self).scoped(*args)
    end

    def scoped(*args)
      new_layer(*args)
    end

    def map
      new_accessor.map
    end

    def document
      @documents.last
    end

    def raw
      document.raw
    end

    def pretty(indent : String? = nil)
      String.build do |sb|
        pretty sb, indent
      end
    end

    def pretty(io : IO, indent : String? = nil)
      indent ||= ""
      @documents.each_with_index do |doc, i|
        io << "\n" if i != 0
        doc.put_pretty io, indent
      end
    end
  end
end
