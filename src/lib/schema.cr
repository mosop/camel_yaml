module Yaml
  module Schema
    macro included
      class ::{{@type}}::Accessor < ::Yaml::Accessor
      end

      macro register_schema
        class ::Yaml::Stream
          def [](schema : ::{{@type}}.class)
            new_layer[schema]
          end
        end

        class ::Yaml::Layer
          def [](schema : ::{{@type}}.class)
            ::{{@type}}::Accessor.new(self, 0, scoped_value(0))
          end
        end

        class ::Yaml::Accessor
          def [](schema : ::{{@type}}.class)
            if prev = @previous_accessor
              ::{{@type}}::Accessor.new(prev, @index.not_nil!, @target)
            else
              ::{{@type}}::Accessor.new(@layer, @document_index, @layer.scoped_value(@document_index))
            end
          end
        end
      end

      macro map(t)
        class Accessor
          def [](index : ::Yaml::Index)
            \{{t}}::Accessor.new(self, index, next_target?(index))
          end
        end
      end

      macro seq(t)
        class Accessor
          def [](index : ::Int32)
            \{{t}}::Accessor.new(self, index, next_target?(index))
          end
        end
      end

      macro key(key, t)
        \{%
          key = key.id
        \%}
        class Accessor
          def \{{key}}
            \{{t}}::Accessor.new(self, \{{key.stringify}}, next_target?(\{{key.stringify}}))
          end
        end
      end
    end
  end
end
