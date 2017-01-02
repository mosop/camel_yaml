module Yaml
  class Exception < ::Exception
  end

  abstract class NoEntry < Exception
    getter target : Accessor::Target

    def initialize(@target, message)
      super message
    end
  end

  class NoIndex < NoEntry
    getter index : Int32

    def initialize(target, @index)
      super target, "No entry at #{index}"
    end
  end

  class NoKey < NoEntry
    getter key : String

    def initialize(target, @key)
      super target, "No entry of #{key}"
    end
  end

  class CantReassignRootNode < Exception
    def initialize
      super "Can't reassign root node."
    end
  end

  class Bug_IllegalFallbackEntryCall < Exception
    def initialize(target)
      super "[BUG] Illegal fallback_entry call: #{target}"
    end
  end

  class Bug_IllegelNewBuilderCall < Exception
    def initialize(target)
      super "[BUG] Illegal new_builder call: #{target}"
    end
  end

  class Bug_IllegalAssignChildValueCall < Exception
    def initialize(target)
      super "[BUG] Illegal assign_child_value call: #{target}"
    end
  end

  class Bug_NotImplemented < Exception
    def initialize(target)
      super "[BUG] Not implemented: #{target}"
    end
  end

  macro __parsing_exception(klass, message)
    class {{klass}} < Exception
      def initialize(pos : Position?)
        super {{message}} + ": #{pos}"
      end
    end
  end

  __parsing_exception QuotedStringNotEnded, "Quoted string not ended"
  __parsing_exception MappingNotEnded, "Mapping not ended"
  __parsing_exception SequenceNotEnded, "Sequence not ended"
  __parsing_exception KeyNotDefined, "Key not defined"
  __parsing_exception AnchorNotDefined, "Anchor not defined"
  __parsing_exception TooManyRootNode, "Too many root node"
  __parsing_exception TooManyYamlDirective, "Too many YAML directive"
  __parsing_exception TooManyAnchor, "Too many anchor"
  __parsing_exception TooManyTag, "Too many tag"
  __parsing_exception DirectiveInDocumentContent, "Directive in document content"
  __parsing_exception IllegalRootNodeType, "Illegal root node type"
  __parsing_exception IllegalNodeTypeToApplyAnchor, "Illegal node type to apply anchor"
  __parsing_exception IllegalNodeTypeToApplyTag, "Illegal node type to apply tag"
  __parsing_exception IllegalNodeTypeToApplyComment, "Illegal node type to apply comment"
  __parsing_exception UnexpectedToken, "Unexpected token"
  __parsing_exception UnexpectedComma, "Unexpected comma"
  __parsing_exception UnexpectedFlowMappingEnd, "Unexpected flow mapping end"
  __parsing_exception Bug_UnexpectedComma, "[BUG] Unexpected comma"
  __parsing_exception Bug_UnexpectedFlowMappingEnd, "[BUG] Unexpected flow mapping end"
  __parsing_exception Bug_UnexpectedFlowSequenceEnd, "[BUG] Unexpected flow sequence end"
end
