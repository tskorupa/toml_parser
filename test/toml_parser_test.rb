require_relative '../lib/toml_parser'
require 'mocha/test_unit'
require 'minitest/autorun'

class TomlParserTest < MiniTest::Test
  def test_toml_parser
    input = :input
    output = :output
    TomlParser::Parser.expects(:parse).with(input).returns(output)

    assert_equal output, TomlParser.load(input)
  end
end
