module Yaml::Nodes
  class Document
    include NodeMixins::Parent
    include NodeMixins::HasPosition

    getter! yaml_directive : YamlDirective?
    getter tag_directives = [] of TagDirective
    getter reserved_directives = [] of ReservedDirective
    getter? value : Entity?
    getter anchors = {} of String => Anchor
    property! start : DocumentStart?
    property! end : DocumentEnd?

    def initialize(@start, pos : Position)
      @position = if start = @start
        start.position
      else
        pos
      end
    end

    def document
      self
    end

    def started?
      @start || @value
    end

    def raise_if_directive_in_content(node)
      if started?
        raise DirectiveInDocumentContent.new(node.position)
      end
    end

    def append_node(node : YamlDirective)
      raise_if_directive_in_content node
      raise TooManyYamlDirective.new(node.position) if @yaml_directive
      @yaml_directive = node
    end

    def append_node(node : TagDirective)
      raise_if_directive_in_content node
      @tag_directives << node
    end

    def append_node(node : ReservedDirective)
      raise_if_directive_in_content node
      @reserved_directives << node
    end

    def append(value : Value)
      Yaml.debug "Doc".ljust(9) + " a  #{value}"
      if v = @value
        unless v.is_a?(Undefined)
          raise TooManyRootNode.new(value.position) if @value
        end
      end
      case value
      when Entity
        value.parent = self
        @value = value
      else
        raise IllegalRootNodeType.new(value.position)
      end
    end

    def value
      @value ||= Undefined.new(@position)
    end

    def raw
      value.raw
    end

    def put_pretty(io : IO, indent : String, first_indent : String? = nil)
      io << first_indent || indent
      io << "---"
      value.put_pretty io, indent, first_indent: "\n#{indent}"
    end

    def to_stream
      Stream.new(position.source.location).tap do |stream|
        stream.documents << self
      end
    end

    def self.undefined(location)
      Document.new(nil, Position.new(Source.new(location)))
    end

    def undefined_value?
      @value.as?(Undefined)
    end

    def nil_or_undefined_value?
      @value.nil? || undefined_value?
    end

    def fallback_for(index : Index)
      if nil_or_undefined_value?
        case index
        when String
          append Mapping.new(position)
        when Int32
          append Sequence.new(position)
        end
      end
    end
  end
end
