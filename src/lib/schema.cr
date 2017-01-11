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
            ::Yaml::Accessor.initialize(::{{@type}}::Accessor.new(*args), self, 0, scoped_value(0))
          end
        end

        class ::Yaml::Accessor
          def [](schema : ::{{@type}}.class, *args)
            if prev = @previous_accessor
              ::Yaml::Accessor.initialize(::{{@type}}::Accessor.new(*args), prev, @index.not_nil!, @target)
            else
              ::Yaml::Accessor.initialize(::{{@type}}::Accessor.new(*args), layer, document_index, layer.scoped_value(document_index))
            end
          end
        end
      end

      macro map(t, *args)
        class Accessor
          def [](index : ::Yaml::Index)
            ::Yaml::Accessor.initialize(\{{t}}::Accessor.new(\{{args.map{|i| i.id}.splat}}), self, index, next_target?(index))
          end
        end
      end

      macro seq(t, *args)
        class Accessor
          def [](index : ::Int32)
            ::Yaml::Accessor.initialize(\{{t}}::Accessor.new(\{{args.map{|i| i.id}.splat}}), self, index, next_target?(index))
          end
        end
      end

      macro key(key, t, *args)
        \{%
          key = key.id
        \%}
        class Accessor
          def \{{key}}
            ::Yaml::Accessor.initialize(\{{t}}::Accessor.new(\{{args.map{|i| i.id}.splat}}), self, \{{key.stringify}}, next_target?(\{{key.stringify}}))
          end
        end
      end
    end
  end
end
