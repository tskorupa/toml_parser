require_relative '../lib/toml_generator'
require 'minitest/autorun'

class TomlGeneratorTest < MiniTest::Test

  def setup
    @generator = TomlGenerator.new
  end

  TEST_CASES = [
    [
      [
        [ TomlGrammar::KeyValue, { 'k1' => 123 } ],
        [ TomlGrammar::KeyValue, { 'k2' => 'foo' } ]
      ],
      {}
    ],
    [
      [
        [ TomlGrammar::KeyOfHash, 'foo' ],
        [ TomlGrammar::KeyValue, { 'k1' => 'a' } ],
        [ TomlGrammar::KeyValue, { 'k2' => 'b' } ],
        [ TomlGrammar::KeyOfHash, 'bar' ],
        [ TomlGrammar::KeyValue, { 'k1' => 1 } ],
        [ TomlGrammar::KeyValue, { 'k2' => 2 } ]
      ],
      {
        'foo' => { 'k1' => 'a', 'k2' => 'b' },
        'bar' => { 'k1' => 1, 'k2' => 2 }
      }
    ],
    [
      [
        [ TomlGrammar::KeyNest, [ 'foo', 'bar', 'quux' ] ],
        [ TomlGrammar::KeyValue, { 'k1' => 'a' } ],
        [ TomlGrammar::KeyValue, { 'k2' => 'b' } ]
      ],
      {
        'foo' => { 'bar' => { 'quux' => { 'k1' => 'a', 'k2' => 'b' } } }
      }
    ],
    [
      [
        [ TomlGrammar::KeyOfArray, 'foo' ],
        [ TomlGrammar::KeyValue, { 'k1' => 'a' } ],
        [ TomlGrammar::KeyValue, { 'k2' => 'b' } ],
        [ TomlGrammar::KeyOfArray, 'foo' ],
        [ TomlGrammar::KeyValue, { 'k1' => 'c' } ],
        [ TomlGrammar::KeyValue, { 'k2' => 'd' } ]
      ],
      {
        'foo' => [{'k1' => 'a', 'k2' => 'b'}, {'k1' => 'c','k2' => 'd'}]
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
