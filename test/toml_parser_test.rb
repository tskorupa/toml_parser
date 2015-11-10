require_relative '../toml_parser'
require 'minitest/autorun'

class TomlParserTest < MiniTest::Test

  TEST_CASES = [
    # Defined as [ INPUT_STRING, EXPECTED_OUTPUT ]
    [ nil, {} ],
    [ "", {} ],
    [
      "[foo]\nk1 = \"a\"\nk2 = \"b\"\n\n[bar]\n\nk1 = 1\nk2 = 2\n",
      {
        'foo' => {
          'k1' => 'a',
          'k2' => 'b',
        },
        'bar' => {
          'k1' => 1,
          'k2' => 2,
        },
      }
    ],
    [
      "[foo.bar.quux]\n\nk1 = \"a\"\nk2 = \"b\"\n",
      {
        'foo' => {
          'bar' => {
            'quux' => {
              'k1' => 'a',
              'k2' => 'b',
            },
          },
        },
      }
    ],
    [
      "[[foo]]\n\nk1 = \"a\"\nk2 = \"b\"\n\n[[foo]]\n\nk1 = \"c\"\nk2 = \"d\"\n",
      {
        'foo' => [
          {
            'k1' => 'a',
            'k2' => 'b',
          },
          {
            'k1' => 'c',
            'k2' => 'd',
          },
        ],
      }
    ]
  ]

  def test_parser
    TEST_CASES.each do |input, expected_output|
      assert_equal expected_output, TomlParser.parse(input)
    end
  end

end
