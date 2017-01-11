module Yaml
  class Layer
    getter! previous_layer : Layer?
    getter! next_layer : Layer?
    @stream : Stream?
    @loader : Io::Loader?
    @saver : Io::Saver?
    setter scope : Array(Index)?

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
      l.scope = indexes.dup
      l
    end

    def scoped_value(doc_index : Int32)
      v = stream.documents[doc_index].value
      scope.each do |i|
        v = v.accessible_entry?(i)
        return nil unless v
      end
      v
    end

    def scope
      @scope || [] of Index
    end

    def next_document_index?(current : Int32)
      current += 1
      if current < stream.documents.size
        current
      end
    end

    def [](index : Int32 | String)
      new_accessor[index]
    end

    def [](indexes : Array(String))
      new_accessor[indexes]
    end

    def []=(index : Int32 | String, value : String)
      new_accessor[index].build do |entry|
        entry.value = value
      end
    end

    def new_accessor
      Accessor.initialize(Accessor.new, self, 0, scoped_value(0))
    end

    def collect_string_index_paths
      new_accessor.collect_string_index_paths
    end

    def save
      if saver = @saver
        saver.save stream
      end
    end
  end
end
