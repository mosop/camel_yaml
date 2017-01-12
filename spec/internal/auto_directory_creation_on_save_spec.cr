require "../spec_helper"

module YamlInternalSpecAutoDirectoryCreationOnSave
  it name do
    Dir.tmp do |dir|
      path = File.join(dir, "test", "test.yml")
      layer = Yaml::Io::File.new(path, stream: Yaml.parse("")).to_layer
      layer["foo"] = "bar"
      layer.save
      File.read(path).chomp.should eq "---\nfoo: bar"
    end
  end
end
