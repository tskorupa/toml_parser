$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'toml_parser/version'
require 'toml_parser/parser'

module TomlParser
  def self.load content
    TomlParser::Parser.parse content
  end
end
