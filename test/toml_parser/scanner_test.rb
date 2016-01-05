require_relative '../../lib/toml_parser/scanner'
require_relative '../../lib/toml_parser/grammar'
require 'mocha/mini_test'
require 'minitest/autorun'

class ScannerTest < MiniTest::Test
  TEST_CASES = [
    # [ SCANER_INPUT_LINE, EXPECTED_SCANNER_OUTPUT_KLASS ]
    [ '[[foo]]', TomlParser::Grammar::KeyOfArray ],
    [ '[foo]', TomlParser::Grammar::KeyOfHash ],
    [ '[foo.bar.baz]', TomlParser::Grammar::KeyNest ],
    [ 'k1 = "a"', TomlParser::Grammar::KeyValue ],
    [ 'k2 = 1', TomlParser::Grammar::KeyValue ],
    [ '"foo"', TomlParser::Grammar::StringLiteral ],
    [ '-12345', TomlParser::Grammar::IntegerLiteral ],
    [ '', NilClass ],
    [ nil, NilClass ]
  ]

  def test_scanner
    TEST_CASES.each do |input_line, expected_klass|
      parsed_line = TomlParser::Scanner.scan(input_line)
      assert_equal expected_klass, parsed_line.class
    end
  end
end
