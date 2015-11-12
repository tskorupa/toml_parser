require 'treetop'

class TomlScanner

  Treetop.load 'lib/toml_grammar.treetop'
  @parser = TomlGrammarParser.new

  def self.scan line
    return if line.nil?
    @parser.parse line
  end

end
