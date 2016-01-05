require 'treetop'

module TomlParser
  module Grammar
    class KeyOfArray < Treetop::Runtime::SyntaxNode
      def value
        # text_value: '[[foo]]', want to retrieve 'foo'
        text_value[2..-3]
      end
    end

    class KeyOfHash < Treetop::Runtime::SyntaxNode
      def value
        # text_value: '[foo]', want to retrieve 'foo'
        text_value[1..-2]
      end
    end

    class KeyNest < Treetop::Runtime::SyntaxNode
      def value
        # text_value: '[foo.bar.baz]', want to retrieve ['foo', 'bar', 'baz']
        text_value.gsub(/(\[|\])/, '').split('.')
      end
    end

    class KeyValue < Treetop::Runtime::SyntaxNode
      def value
        # text_value: 'k1 = "a"', want to retrieve '{ k1: "a" }'
        k, v = text_value.split('=')
        k.strip!
        v.strip!
        { k => parse_value_to_type(v) }
      end

      private

      def parse_value_to_type val
        return val.to_i unless val.match(/\"(.+|)\"/)
        val.delete "\""
      end
    end

    class StringLiteral < Treetop::Runtime::SyntaxNode
      def value
        text_value
      end
    end

    class IntegerLiteral < Treetop::Runtime::SyntaxNode
      def value
        text_value.to_i
      end
    end
  end
end
