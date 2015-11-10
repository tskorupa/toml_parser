require 'treetop'
require_relative 'lib/toml_grammar'

class TomlParser

  Treetop.load 'lib/toml_grammar.treetop'
  @parser = TomlGrammarParser.new

  class << self

    def parse string
      {}.tap do |output|
        current_ptr = output
        current_values = nil
        each_line(string) do |line|
          parsed_line = @parser.parse(line)

          if [ TomlGrammar::KeyNest, TomlGrammar::KeyOfArray ].include?(parsed_line.class) &&
              current_ptr.is_a?(Array) && current_values
            current_ptr << current_values
            current_values = nil
          end

          case parsed_line.class.to_s
          when TomlGrammar::KeyNest.to_s then
            parsed_line.value.each do |key|
              current_ptr[ key ] ||= {}
              current_ptr = current_ptr[ key ]
            end
          when TomlGrammar::KeyOfHash.to_s then
            output[ parsed_line.value ] ||= {}
            current_ptr = output[ parsed_line.value ]
          when TomlGrammar::KeyOfArray.to_s then
            output[ parsed_line.value ] ||= []
            current_ptr = output[ parsed_line.value ]
            current_values = {}
          when TomlGrammar::KeyValue.to_s then
            if current_ptr.is_a? Hash
              current_ptr.merge! parsed_line.value
            elsif current_ptr.is_a? Array
              current_values.merge! parsed_line.value
            end
          end
        end

        if current_ptr.is_a?(Array) && current_values
          current_ptr << current_values
          current_values = nil
        end
      end
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
