require 'treetop'

module TomlParser
  class Scanner
    Treetop.load 'lib/toml_parser/grammar.treetop'
    @parser = TomlParser::GrammarParser.new

    def self.scan line
      return if line.nil?
      @parser.parse line
    end
  end
end
