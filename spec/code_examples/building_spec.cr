require "../spec_helper"

module YamlCodeExamplesBuilding
  Io = IO::Memory.new
  def self.puts(s)
    Io.puts s
  end

  it name do
    yaml = Yaml.map do |map|
      map["faces"].seq do |seq|
        seq.comment = <<-EOS
         add smiley icons below
         one face a row
        EOS
        seq.s ":)"
        seq.s ":("
        seq.s ":P"
      end
    end

    puts yaml.pretty

    yaml["faces"][0].build do |s|
      s.value = ";)"
      s.trailing_comment = " wink!"
    end

    puts yaml.pretty

    Io.rewind
    Io.gets_to_end.chomp.should eq <<-EOS
    ---
    faces:
    # add smiley icons below
    # one face a row
    - :)
    - :(
    - :P
    ---
    faces:
    # add smiley icons below
    # one face a row
    - ;) # wink!
    - :(
    - :P
    EOS
  end
end
