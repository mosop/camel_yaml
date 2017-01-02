module Yaml::Io
  module Saver
    abstract def save(stream : StreamData)
  end
end
