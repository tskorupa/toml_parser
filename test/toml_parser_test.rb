require_relative '../toml_parser'
require 'mocha/test_unit'
require 'minitest/autorun'

class TomlParserTest < MiniTest::Test
  def test_parser
    [ 0, 1, 2 ].each do |iterations|
      assert run_parser(iterations: iterations, line: 'foo')
    end
  end

  private

  def run_parser iterations:, line:
    mock = MiniTest::Mock.new
    TomlGenerator.expects(:new).returns(mock)
    TomlScanner.expects(:scan).times(iterations).returns(line)
    TomlParser.parse input_string(mock: mock, iterations: iterations, line: line)
    mock.verify
  end

  def input_string mock:, iterations:, line:
    input_arr = []

    iterations.times do
      mock.expect(:add, 'garbage', [ line ])
      input_arr << line
    end
    mock.expect :complete_tree, 'more garbage'

    input_arr.join("\n")
  end
end
