require "./nodes"

module Yaml
  class Accessor
    alias Target = Nodes::Value | Nodes::MappingEntry | Nodes::SequenceEntry
    alias Index = Int32 | String

    class NoEntry < Exception
      getter type : String?
      getter layers : Array(Accessor)

      def initialize(@type, @layers)
        super(String.build do |sb|
          sb << "No YAML"
          if type
            sb << " "
            sb << type
          end
          sb << " entry:"
          @layers.each do |i|
            sb << "\n " if @layers.size >= 2
            sb << " "
            i.scope.each do |j|
              sb << "["
              sb << j.inspect
              sb << "]"
            end
            loc = i.document.position.source.location
            if loc.starts_with?("(")
              sb << " "
              sb << loc
            else
              sb << " ("
              sb << loc
              sb << ")"
            end
          end
        end)
      end
    end

    getter! layer : Layer?
    getter! document_index : Int32?
    getter! previous_accessor : Accessor?
    getter! index : Index?
    getter? target : Target?

    def self.initialize(new_instance : Accessor, layer : Layer, document_index : Int32, target : Target?)
      new_instance._layer(layer)._document_index(document_index)._target(target)
    end

    def self.initialize(new_instance : Accessor, previous_accessor : Accessor, index : Index, target : Target?)
      new_instance._previous_accessor(previous_accessor)._index(index)._target(target)
    end

    def _layer(v : Layer)
      @layer = v
      self
    end

    def _document_index(v : Int32)
      @document_index = v
      self
    end

    def _previous_accessor(v : Accessor)
      @previous_accessor = v
      @layer = v.layer
      @document_index = v.document_index
      self
    end

    def _index(v : Index)
      @index = v
      self
    end

    def _target(v : Target?)
      @target = v
      self
    end

    def document
      layer.stream.documents[document_index]
    end

    @local_scope : Array(Index)?
    def local_scope
      @local_scope ||= begin
        if scope.size > layer.scope.size
          scope[layer.scope.size..-1]
        else
          [] of Index
        end
      end
    end

    @scope : Array(Index)?
    def scope
      @scope ||= begin
        if prev = @previous_accessor
          a = prev.scope.dup
          a << index
          a
        else
          [] of Index
        end
      end
    end

    macro access(to, &block)
      {%
        schema = @type.name.split("::")[0..-2].join("::").id
        to = to.id
      %}
      def get_{{to}}?
        {{block.body}}
      end

      def {{to}}?(layers : Array(::Yaml::Accessor)? = nil)
        layers << self if layers
        if v = get_{{to}}?
          v
        elsif l = next_layer?
          l[self][::{{schema}}].{{to}}?(layers)
        end
      end

      def {{to}}
        layers = [] of ::Yaml::Accessor
        if v = {{to}}?(layers)
          v
        else
          raise NoEntry.new(nil, layers)
        end
      end
    end

    @first_accessor : Accessor?
    def first_accessor
      @first_accessor ||= @previous_accessor ? previous_accessor.first_accessor : self
    end

    def fallback_for(index : Index)
      if prev = @previous_accessor
        prev.fallback_for self.index
        @target = _fallback(self.index, index) unless @target
      else
        document.fallback_for index
        @target = document.value
      end
    end

    def _fallback(index : Int32, child_index : String)
      raise "Not implemented."
    end

    def _fallback(index : Int32, child_index : Int32)
      raise "Not implemented."
    end

    def _fallback(index : String, child_index : Int32)
      raise "Not implemented."
    end

    def _fallback(index : String, child_index : String)
      previous_accessor.map[index] = Nodes::Mapping.new(document.position)
    end

    def [](index : Index)
      Accessor.initialize(Accessor.new, self, index, next_target?(index))
    end

    def [](accessor : Accessor)
      self[accessor.local_scope]
    end

    def [](indexes : Array(Index))
      current = self
      indexes.each do |index|
        current = current[index]
      end
      current
    end

    def []=(index : Index, value)
      fallback_for index
      case i = index
      when String
        map[i] = value
      when Int32
        seq[i] = value
      end
    end

    def position
      if target = @target
        if v = target.position
          return v
        end
      end
      if prev = @previous_accessor
        if v = prev.position
          return v
        end
      end
      document.position
    end

    def quote=(value : String)
      self.value = Nodes::DoubleQuotedString.new(value, position)
    end

    def value=(value)
      if prev = @previous_accessor
        prev[index] = value
      else
        document.value = value
      end
    end

    def next_target?(index : Index, layers : Array(Accessor)? = nil)
      layers << self if layers
      if target = @target
        if entry = target.accessible_entry?(index)
          return entry
        end
      end
      if l = next_layer?
        l[self].next_target?(index, layers)
      end
    end

    def map?(layers : Array(Accessor)? = nil)
      layers << self if layers
      if target = @target
        if map = target.accessible_mapping?
          return map
        end
      end
      if l = next_layer?
        l[self].map?(layers)
      end
    end

    def map
      layers = [] of Accessor
      if map = map?(layers)
        map
      else
        raise NoEntry.new("mapping", layers)
      end
    end

    def seq?(layers : Array(Accessor)? = nil)
      layers << self if layers
      if target = @target
        if seq = target.accessible_sequence?
          return seq
        end
      end
      if l = next_layer?
        l[self].seq?(layers)
      end
    end

    def seq
      layers = [] of Accessor
      if seq = seq?(layers)
        seq
      else
        raise NoEntry.new("sequence", layers)
      end
    end

    def node?(layers : Array(Accessor)? = nil)
      layers << self if layers
      if target = @target
        return target
      end
      if l = next_layer?
        l[self].s?(layers)
      end
    end

    def node(layers : Array(Accessor)? = nil)
      layers = [] of Accessor
      if node = node?(layers)
        node
      else
        raise NoEntry.new(nil, layers)
      end
    end

    def s?(layers : Array(Accessor)? = nil)
      layers << self if layers
      if target = @target
        if s = target.raw_string?
          return s
        end
      end
      if l = next_layer?
        l[self].s?(layers)
      end
    end

    def s
      layers = [] of Accessor
      if s = s?(layers)
        s
      else
        raise NoEntry.new("scalar", layers)
      end
    end

    def h?(layers : Array(Accessor)? = nil)
      layers << self if layers
      if target = @target
        if h = target.raw_hash?
          return h
        end
      end
      if l = next_layer?
        l[self].h?(layers)
      end
    end

    def h
      layers = [] of Accessor
      if h = h?(layers)
        h
      else
        raise NoEntry.new("mapping", layers)
      end
    end

    def a?(layers : Array(Accessor)? = nil)
      layers << self if layers
      if target = @target
        if a = target.raw_array?
          return a
        end
      end
      if l = next_layer?
        l[self].a?(layers)
      end
    end

    def a
      layers = [] of Accessor
      if a = a?(layers)
        a
      else
        raise NoEntry.new("sequence", layers)
      end
    end

    def key?(layers : Array(Accessor)? = nil)
      layers << self if layers
      if target = @target
        if key = target.accessible_key?
          return key
        end
      end
      if l = next_layer?
        l[self].key?(layers)
      end
    end

    def key
      layers = [] of Accessor
      if key = key?(layers)
        key
      else
        raise NoEntry.new("mapping", layers)
      end
    end

    def keys?(layers : Array(Accessor)? = nil)
      layers << self if layers
      if target = @target
        if keys = target.accessible_keys?
          return keys
        end
      end
      if l = next_layer?
        l[self].keys?(layers)
      end
    end

    def keys
      layers = [] of Accessor
      if keys = keys?(layers)
        keys
      else
        raise NoEntry.new("mapping", layers)
      end
    end

    def each
      current = self
      keys = Set(String).new
      loop do
        next_keys = Set(String).new
        if target = current.target?
          target.each_accessible_key do |key|
            next if keys.includes?(key)
            next_keys << key
            yield current[key]
          end
        end
        l = current.next_layer?
        return unless l
        current = l[current]
        keys.merge! next_keys
      end
    end

    def build
      if target = @target
        yield target.new_builder(nil, nil)
      else
        raise NoEntry.new(nil, [self] of Accessor)
      end
    end

    def next_layer?
      if di = layer.next_document_index?(document_index)
        layer.scoped_accessor(di)
      elsif l = layer.next_layer?
        l.scoped_accessor(0)
      end
    end

    def collect_string_index_paths
      map.collect_string_index_paths
    end

    def save
      layer.save
    end

    def inspect(io : IO)
      to_s io
    end

    def accessor_count
      n = 1
      current = self
      while current = current.previous_accessor?
        n += 1
      end
      n
    end
  end
end

require "./accessor/*"
