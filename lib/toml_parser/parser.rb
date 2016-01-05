require_relative 'scanner'
require_relative 'generator'

module TomlParser
  class Parser
    class << self
      def parse string
        generator = TomlParser::Generator.new

        each_line(string) do |line|
          parsed_line = TomlParser::Scanner.scan(line)
          next if parsed_line.nil?

          generator.add parsed_line
        end

        generator.complete_tree
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
end
