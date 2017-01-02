module Yaml
  class Parser
    @read_channel = Channel(String?).new(1000)
    getter? eof = false

    def start_to_read(io)
      future do
        begin
          while line = io.gets
            @read_channel.send line
          end
        ensure
          begin
            @read_channel.send nil
          rescue
          end
        end
        nil
      end
    end

    def gets
      if l = @read_channel.receive
        l
      else
        @eof = true
        nil
      end
    end

    def read_line
      unless eof?
        if line = gets
          @source.hard_lines << line
          line
        end
      end
    end

    def get_line
      @source.lines[@line]? || if line = read_line
        @source.line_indexes << @source.hard_lines.size - 1
        line = String.build do |builder|
          if m = TRAILING_BACKSLASH.match(line)
            builder << m.pre_match
            while l = read_line
              if m = TRAILING_BACKSLASH.match(l)
                builder << m.pre_match
              else
                break
              end
            end
          else
            builder << line
          end
        end
        @source.lines << line
        line
      end
    end

    def eos?
      @current_line.nil?
    end

    def eol?
      !testable_line
    end

    def testable_line
      if line = @current_line
        if @column < line.size
          line
        end
      end
    end

    def test(pattern : Regex, ignore_case = false)
      if line = testable_line
        @match = pattern.match(line[@column..-1], options: ignore_case ? Regex::Options::IGNORE_CASE : Regex::Options.new(0))
      end
    end

    def scan(pattern : Regex, ignore_case = false)
      if m = test(pattern, ignore_case)
        move_next m.end.not_nil!
        m
      end
    end

    def test(s : String)
      if line = testable_line
        line[@column..-1].starts_with?(s)
      end
    end

    def scan(s : String)
      if test(s)
        move_next s.size
        true
      end
    end

    def scan(len : Int32)
      if line = testable_line
        s = line[@column..([@column + len, line.size].min - 1)]
        move_next s.size
        s
      end
    end

    def scan_left
      if line = testable_line
        s = line[@column..-1]
        move_next s.size
        s
      else
        ""
      end
    end

    def move_next(len : Int32)
      @column += len
    end

    def next_line
      if line = @current_line
        @line += 1
        @column = 0
        @current_line = get_line
      end
    end

    def start(trail = nil, &block : LineAndColumn ->)
      if trail
        self.trail(trail) do |loc|
          yield loc
        end
      else
        lead do |loc|
          yield loc
        end
      end
    end

    def lead(&block : LineAndColumn ->)
      last = line_and_column
      result = yield line_and_column
      unless result
        @line, @column = last.to_tuple
        @current_line = @source.lines[@line]?
      end
      result
    end

    def trail(loc, &block : LineAndColumn ->)
      if trails?(loc)
        lead do |loc|
          yield loc
        end
      end
    end

    def trails?(loc)
      loc.line == @line
    end

    def start
      line_and_column
    end

    def line_and_column(line : Int32? = nil, column : Int32? = nil)
      LineAndColumn.new(line || @line, column || @column)
    end

    def position(line_and_column : LineAndColumn? = nil)
      Position.new(@source, line_and_column || self.line_and_column)
    end

    def mostleft(*args)
      a = [] of LineAndColumn
      args.each do |arg|
        case arg
        when LineAndColumn
          a << arg
        when Position
          a << arg.line_and_column
        when NodeMixins::HasPosition
          a << arg.position.line_and_column
        end
      end
      Position.new(@source, a.min)
    end
  end
end
