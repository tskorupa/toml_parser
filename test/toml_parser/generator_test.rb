require_relative '../../lib/toml_parser/generator'
require 'minitest/autorun'

class GeneratorTest < MiniTest::Test
  def setup
    @generator = TomlParser::Generator.new
  end

  TEST_CASES = [
    [
      [
        [ TomlParser::Grammar::KeyValue, { 'k1' => 123 } ],
        [ TomlParser::Grammar::KeyValue, { 'k2' => 'foo' } ]
      ],
      {}
    ],
    [
      [
        [ TomlParser::Grammar::KeyOfHash, 'foo' ],
        [ TomlParser::Grammar::KeyValue, { 'k1' => 'a' } ],
        [ TomlParser::Grammar::KeyValue, { 'k2' => 'b' } ],
        [ TomlParser::Grammar::KeyOfHash, 'bar' ],
        [ TomlParser::Grammar::KeyValue, { 'k1' => 1 } ],
        [ TomlParser::Grammar::KeyValue, { 'k2' => 2 } ]
      ],
      {
        'foo' => { 'k1' => 'a', 'k2' => 'b' },
        'bar' => { 'k1' => 1, 'k2' => 2 }
      }
    ],
    [
      [
        [ TomlParser::Grammar::KeyNest, %w( foo bar quux ) ],
        [ TomlParser::Grammar::KeyValue, { 'k1' => 'a' } ],
        [ TomlParser::Grammar::KeyValue, { 'k2' => 'b' } ]
      ],
      {
        'foo' => {
          'bar' => {
            'quux' => { 'k1' => 'a', 'k2' => 'b' }
          }
        }
      }
    ],
    [
      [
        [ TomlParser::Grammar::KeyOfArray, 'foo' ],
        [ TomlParser::Grammar::KeyValue, { 'k1' => 'a' } ],
        [ TomlParser::Grammar::KeyValue, { 'k2' => 'b' } ],
        [ TomlParser::Grammar::KeyOfArray, 'foo' ],
        [ TomlParser::Grammar::KeyValue, { 'k1' => 'c' } ],
        [ TomlParser::Grammar::KeyValue, { 'k2' => 'd' } ]
      ],
      {
        'foo' => [
          { 'k1' => 'a', 'k2' => 'b' },
          { 'k1' => 'c', 'k2' => 'd' }
        ]
      }
    ]
  ]

  def test_generator
    TEST_CASES.each do |instructions, expected_tree|
      instructions.each do |klass, value|
        parsed_line = stub_parsed_line(klass, value)
        @generator.add parsed_line
      end
      assert_equal expected_tree, @generator.complete_tree
    end
  end

  private

  def stub_parsed_line klass, value
    obj = Minitest::Mock.new
    obj.expect :class, klass
    obj.expect :value, value
    obj
  end
end
