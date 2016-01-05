require 'treetop'
require_relative '../../lib/toml_parser/grammar'
require 'minitest/autorun'

class GrammerParserTest < MiniTest::Test
  def setup
    Treetop.load 'lib/toml_parser/grammar.treetop'
    @parser = TomlParser::GrammarParser.new
  end

  TEST_CASES = [
    # Defined as [ INPUT_STRING, EXPECTED_OUTPUT ]
    [ '[foo.bar.baz]', %w( foo bar baz ) ],
    [ '[[foobarbaz]]', 'foobarbaz' ],
    [ '[foo]', 'foo' ],
    [ 'foo', nil ],
    [ 'k1 = "a"', { 'k1' => 'a' } ],
    [ 'k1 = -1', { 'k1' => -1 } ],
    [ 'k1 = 0', { 'k1' => 0 } ],
    [ 'k1 = 1', { 'k1' => 1 } ],
    [ '-1', -1 ],
    [ '0', 0 ],
    [ '9999', 9999 ],
    [ '"a"', "\"a\"" ]
  ]

  def test_parser
    TEST_CASES.each do |input, expected_output|
      result = @parser.parse(input)

      if expected_output.nil?
        assert_nil result
      else
        assert_equal expected_output, result.value
      end
    end
  end
end
