module Yaml
  class Parser
    LINE_BREAK = /\r\n|\n|\r/
    TRAILING_BACKSLASH = /\\$/
    SPACE_TAB = /^[ \t]/
    SPACES_TABS = /^[ \t]+/
    SPACE_LINE = /^[ \t]*$/
    DIRECTIVE = /^%([^#\s]|\s(?!#))+/
    DOCUMENT_START = /^---(?=\s|$)/
    DOCUMENT_END = /^\.\.\.(?=\s|$)/
    UNICODE_ESCAPE8 = /^\\x([0-9a-fA-F]{2})/
    UNICODE_ESCAPE16 = /^\\u([0-9a-fA-F]{4})/
    UNICODE_ESCAPE32 = /^\\U([0-9a-fA-F]{8})/
    TAG = /^![^\s]+/
    ANCHOR = /^&[^\s]+/
    ALIAS = /^\*[^\s]+/
    MAPPING_KEY_INDICATOR = /^\?(?=\s|$)/
    MAPPING_VALUE_INDICATOR = /^:(?=\s|$)/
    SEQUENCE_ENTRY_INDICATOR = /^-(?=\s|$)/
    KEYABLE_COLON = /^:(?=\s|$)/
    SCALAR_SPACE = /^[ \t](?!#|$)/
    KEYABLE_SCALAR_SPACE = /^[ \t](?!:|#|$)/
  end
end
