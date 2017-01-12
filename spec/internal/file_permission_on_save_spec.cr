require "../spec_helper"

module YamlInternalSpecFilePermissionOnSave
  it name do
    Dir.tmp do |dir|
      path = File.join(dir, "test", "test.yml")
      layer = Yaml::Io::File.new(path, stream: Yaml.parse(""), permission: 0o600).to_layer
      layer.save
      (File.stat(path).perm & 0o777).should eq 0o600
    end
  end
end
