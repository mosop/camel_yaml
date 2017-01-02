require "../spec_helper"

module YamlWikiLayeringDocuments
  describe name do
    it "" do
      layer = Yaml.parse(<<-EOS
      :): hello
      EOS
      ).new_layer

      layer.next_layer = Yaml.parse(<<-EOS
      :(: bye
      EOS
      ).new_layer

      layer[":)"].s.should eq "hello"
      layer[":("].s.should eq "bye"
    end

    it "Previous First" do
      layer = Yaml.parse(<<-EOS
      :): hello
      EOS
      ).new_layer

      layer.next_layer = Yaml.parse(<<-EOS
      :): bye
      EOS
      ).new_layer

      layer[":)"].s.should eq "hello"
    end

    it "Default Scope" do
      yaml = Yaml.parse(<<-EOS
      development:
        db:
          adapter: sqlite
      production:
        db:
          adapter: postgresql
      EOS
      )

      layer = yaml.scoped("production")
      layer["db"]["adapter"].s.should eq "postgresql"
    end
  end
end
