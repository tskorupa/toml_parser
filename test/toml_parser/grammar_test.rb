require_relative '../../lib/toml_parser/grammar'
require 'mocha/mini_test'
require 'minitest/autorun'

class GrammarTest < MiniTest::Test
  def test_key_of_array_klass
    TomlParser::Grammar::KeyOfArray.any_instance.stubs initialize: nil, text_value: '[[foo]]'
    assert_equal 'foo', TomlParser::Grammar::KeyOfArray.new.value
  end

  def test_key_of_hash_klass
    TomlParser::Grammar::KeyOfHash.any_instance.stubs initialize: nil, text_value: '[foo]'
    assert_equal 'foo', TomlParser::Grammar::KeyOfHash.new.value
  end

  def test_key_nest_klass
    TomlParser::Grammar::KeyNest.any_instance.stubs initialize: nil, text_value: '[foo.bar.baz]'
    assert_equal %w( foo bar baz ), TomlParser::Grammar::KeyNest.new.value
  end

  def test_value_klass
    [
      [ 'k1 = "a"', { 'k1' => 'a' } ],
      [ 'k1 = 1', { 'k1' => 1 } ],
      [ 'k1 = -1', { 'k1' => -1 } ]
    ].each do |text_value, expected|
      TomlParser::Grammar::KeyValue.any_instance.stubs initialize: nil, text_value: text_value
      assert_equal expected, TomlParser::Grammar::KeyValue.new.value
    end
  end

  def test_string_literal_klass
    TomlParser::Grammar::StringLiteral.any_instance
      .stubs initialize: nil, text_value: '[foo.bar.baz]'
    assert_equal '[foo.bar.baz]', TomlParser::Grammar::StringLiteral.new.value
  end

  def test_integer_literal_klass
    TomlParser::Grammar::IntegerLiteral.any_instance.stubs initialize: nil, text_value: '1000'
    assert_equal 1000, TomlParser::Grammar::IntegerLiteral.new.value
  end
end
