require_relative 'toml_parser/version'
require_relative 'toml_parser/parser'

module TomlParser
  def self.load content
    TomlParser::Parser.parse content
  end
end
