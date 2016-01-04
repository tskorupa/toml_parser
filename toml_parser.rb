require_relative 'lib/toml_scanner'
require_relative 'lib/toml_generator'

class TomlParser
  class << self
    def parse string
      generator = TomlGenerator.new

      each_line(string) do |line|
        parsed_line = TomlScanner.scan(line)
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
