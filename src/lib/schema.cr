module Yaml
  module Schema
    macro included
      class ::{{@type}}::Accessor < ::Yaml::Accessor
      end

      macro register_schema
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
              ::Yaml::Accessor.initialize(::{{@type}}::Accessor.new(*args), prev, @index.not_nil!, @target)
            else
              layer.scoped_accessor(document_index, ::{{@type}}::Accessor.new(*args))
            end
          end
        end
      end

      macro map(t, *args)
        class Accessor
          def [](index : ::String)
            \{% if args.empty? %}
              ::Yaml::Accessor.initialize(\{{t}}::Accessor.new, self, index, next_target?(index))
            \{% else %}
            ::Yaml::Accessor.initialize(\{{t}}::Accessor.new(\{{args.map{|i| i.id}.splat}}), self, index, next_target?(index))
            \{% end %}
          end

          def each
            super do |i|
              \{% if args.empty? %}
                j = i[\{{t}}]
              \{% else %}
                j = i[\{{t}}, \{{args.map{|i| i.id}.splat}}]
              \{% end %}
              yield j
            end
          end
        end
      end

      macro seq(t, *args)
        class Accessor
          def [](index : ::Int32)
            \{% if args.empty? %}
              ::Yaml::Accessor.initialize(\{{t}}::Accessor.new, self, index, next_target?(index))
            \{% else %}
            ::Yaml::Accessor.initialize(\{{t}}::Accessor.new(\{{args.map{|i| i.id}.splat}}), self, index, next_target?(index))
            \{% end %}
          end

          def each
            super do |i|
              \{% if args.empty? %}
                j = i[\{{t}}]
              \{% else %}
                j = i[\{{t}}, \{{args.map{|i| i.id}.splat}}]
              \{% end %}
              yield j
            end
          end
        end
      end

      macro key(key, t, *args)
        \{%
          key = key.id
        \%}
        class Accessor
          def \{{key}}
            \{% if args.empty? %}
              ::Yaml::Accessor.initialize(\{{t}}::Accessor.new, self, \{{key.stringify}}, next_target?(\{{key.stringify}}))
            \{% else %}
              ::Yaml::Accessor.initialize(\{{t}}::Accessor.new(\{{args.map{|i| i.id}.splat}}), self, \{{key.stringify}}, next_target?(\{{key.stringify}}))
            \{% end %}
          end
        end
      end
    end
  end
end
