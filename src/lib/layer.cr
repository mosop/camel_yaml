module Yaml
  class Layer
    getter! previous_layer : Layer?
    getter! next_layer : Layer?
    @stream : Stream?
    @loader : Io::Loader?
    @saver : Io::Saver?
    getter scope = [] of Index

    def initialize(@stream : Stream)
    end

    def initialize(@stream : Stream, @saver : Io::Saver)
    end

    def initialize(@loader : Io::Loader)
    end

    def initialize(@loader : Io::Loader, @saver : Io::Saver)
    end

    def initialize(@stream, @loader, @saver, @previous_layer, @next_layer)
    end

    def stream
      @stream ||= if loader = @loader
        loader.load
      else
        Yaml.parse("")
      end
    end

    def first_layer
      @previous_layer ? previous_layer.first_layer : self
    end

    def last_layer
      @next_layer ? next_layer.last_layer : self
    end

    def previous_layer=(value : Layer)
      value._next_layer = self
      @previous_layer = value
    end

    def _previous_layer=(value : Layer)
      @previous_layer = value
    end

    def next_layer=(value : Layer)
      value._previous_layer = self
      @next_layer = value
    end

    def _next_layer=(value : Layer)
      @next_layer = value
    end

    def dup
      scoped scope
    end

    def scoped(*args)
      a = [] of Index
      args.each do |arg|
        a << arg
      end
      scoped a
    end

    def scoped(indexes : Array(Index))
      l = Layer.new(@stream, @loader, @saver, @previous_layer, @next_layer)
      l.scope.concat indexes
      l
    end

    def initialize_accessor(doc_index : Int32, accessor)
      Accessor.initialize(accessor, self, doc_index, stream.documents[doc_index].value)
    end

    def scoped_accessor(doc_index : Int32)
      initialize_accessor(doc_index, Accessor.new)[@scope]
    end

    def scoped_accessor(doc_index : Int32, accessor)
      if @scope.empty?
        initialize_accessor(doc_index, accessor)
      else
        prev = initialize_accessor(doc_index, Accessor.new)[@scope[0..-2]]
        i = @scope.last
        Accessor.initialize(accessor, prev, i, prev.next_target?(i))
      end
    end

    def next_document_index?(current : Int32)
      current += 1
      if current < stream.documents.size
        current
      end
    end

    def [](index : Index)
      scoped_accessor(0)[index]
    end

    def [](indexes : Array(Index) | Array(String) | Array(Int32))
      scoped_accessor(0)[indexes]
    end

    def []=(index : Index, value)
      scoped_accessor(0)[index] = value
    end

    def collect_string_index_paths
      scoped_accessor(0).collect_string_index_paths
    end

    def save
      if saver = @saver
        saver.save stream
      end
    end
  end
end
