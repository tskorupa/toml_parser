require_relative '../lib/toml_grammar'
require 'mocha/mini_test'
require 'minitest/autorun'

class TomlGrammarTest < MiniTest::Test
  def test_key_of_array_klass
    TomlGrammar::KeyOfArray.any_instance.stubs initialize: nil, text_value: '[[foo]]'
    assert_equal 'foo', TomlGrammar::KeyOfArray.new.value
  end

  def test_key_of_hash_klass
    TomlGrammar::KeyOfHash.any_instance.stubs initialize: nil, text_value: '[foo]'
    assert_equal 'foo', TomlGrammar::KeyOfHash.new.value
  end

  def test_key_nest_klass
    TomlGrammar::KeyNest.any_instance.stubs initialize: nil, text_value: '[foo.bar.baz]'
    assert_equal %w( foo bar baz ), TomlGrammar::KeyNest.new.value
  end

  def test_value_klass
    [
      [ 'k1 = "a"', { 'k1' => 'a' } ],
      [ 'k1 = 1', { 'k1' => 1 } ],
      [ 'k1 = -1', { 'k1' => -1 } ]
    ].each do |text_value, expected|
      TomlGrammar::KeyValue.any_instance.stubs initialize: nil, text_value: text_value
      assert_equal expected, TomlGrammar::KeyValue.new.value
    end
  end

  def test_string_literal_klass
    TomlGrammar::StringLiteral.any_instance.stubs initialize: nil, text_value: '[foo.bar.baz]'
    assert_equal '[foo.bar.baz]', TomlGrammar::StringLiteral.new.value
  end

  def test_integer_literal_klass
    TomlGrammar::IntegerLiteral.any_instance.stubs initialize: nil, text_value: '1000'
    assert_equal 1000, TomlGrammar::IntegerLiteral.new.value
  end
end
