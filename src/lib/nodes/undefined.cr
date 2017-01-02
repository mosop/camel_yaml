module Yaml::Nodes
  class Undefined < Scalar
    include NodeMixins::Null
  end
end
