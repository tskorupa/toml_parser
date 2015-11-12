require_relative '../lib/toml_scanner'
require_relative '../lib/toml_grammar'
require 'mocha/mini_test'
require 'minitest/autorun'

class TomlScannerTest < MiniTest::Test

  TEST_CASES = [
    # [ SCANER_INPUT_LINE, EXPECTED_SCANNER_OUTPUT_KLASS ]
    [ '[[foo]]', TomlGrammar::KeyOfArray ],
    [ '[foo]', TomlGrammar::KeyOfHash ],
    [ '[foo.bar.baz]', TomlGrammar::KeyNest ],
    [ 'k1 = "a"', TomlGrammar::KeyValue ],
    [ 'k2 = 1', TomlGrammar::KeyValue ],
    [ '"foo"', TomlGrammar::StringLiteral ],
    [ '-12345', TomlGrammar::IntegerLiteral ],
    [ '', NilClass ],
    [ nil, NilClass ]
  ]

  def test_scanner
    TEST_CASES.each do |input_line, expected_klass|
      parsed_line = TomlScanner.scan(input_line)
      assert_equal expected_klass, parsed_line.class
    end
  end

end
