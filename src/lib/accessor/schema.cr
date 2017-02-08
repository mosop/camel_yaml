module Yaml
  class Accessor
    macro inherited
      class ::Yaml::Stream
        def [](schema : ::{{@type}}.class, *args)
          new_layer[schema, *args]
        end
      end

      class ::Yaml::Layer
        def [](schema : ::{{@type}}.class, *args)
          scoped_accessor(0)[schema, *args]
        end
      end

      class ::Yaml::Accessor
        def [](schema : ::{{@type}}.class, *args)
          if prev = @previous_accessor
            ::Yaml::Accessor.initialize(::{{@type}}.new(*args), prev, @index.not_nil!, @target)
          else
            layer.scoped_accessor(document_index, ::{{@type}}.new(*args))
          end
        end
      end
    end

    macro custom_map(t, *args)
      def [](index : ::String)
        {% if args.empty? %}
          ::Yaml::Accessor.initialize({{t}}.new, self, index, next_target?(index))
        {% else %}
          ::Yaml::Accessor.initialize({{t}}.new({{args.map{|i| i.id}.splat}}), self, index, next_target?(index))
        {% end %}
      end

      def each
        super do |i|
          {% if args.empty? %}
            j = i[{{t}}]
          {% else %}
            j = i[{{t}}, {{args.map{|i| i.id}.splat}}]
          {% end %}
          yield j
        end
      end
    end

    macro custom_seq(t, *args)
      def [](index : ::Int32)
        {% if args.empty? %}
          ::Yaml::Accessor.initialize({{t}}.new, self, index, next_target?(index))
        {% else %}
          ::Yaml::Accessor.initialize({{t}}.new({{args.map{|i| i.id}.splat}}), self, index, next_target?(index))
        {% end %}
      end

      def each
        super do |i|
          {% if args.empty? %}
            j = i[{{t}}]
          {% else %}
            j = i[{{t}}, {{args.map{|i| i.id}.splat}}]
          {% end %}
          yield j
        end
      end
    end

    macro custom_key(key, t, *args)
      {%
        key = key.id
      %}
      def {{key}}
        {% if args.empty? %}
          ::Yaml::Accessor.initialize({{t}}.new, self, {{key.stringify}}, next_target?({{key.stringify}}))
        {% else %}
          ::Yaml::Accessor.initialize({{t}}.new({{args.map{|i| i.id}.splat}}), self, {{key.stringify}}, next_target?({{key.stringify}}))
        {% end %}
      end
    end
  end
end
