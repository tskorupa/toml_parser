require 'treetop'
require_relative 'lib/toml_generator'

class TomlParser

  Treetop.load 'lib/toml_grammar.treetop'
  @parser = TomlGrammarParser.new

  class << self

    def parse string
      generator = TomlGenerator.new

      each_line(string) do |line|
        parsed_line = @parser.parse(line)
        next if parsed_line.nil?

        generator.add parsed_line
      end
      generator.finalize

      return generator.complete_tree
    end

    private

    def each_line string
      return if string.nil? || string.empty?

      string.split("\n").each do |line|
        yield line
      end
    end

  end

end
