require 'deep_merge'
require_relative 'grammar'

module TomlParser
  class Generator
    def initialize
      @wip_tree = {}
      @node = @current = nil
    end

    def add parsed_line
      @subject = parsed_line.value
      klass = parsed_line.class.to_s

      determine_default_value(klass)

      if TomlParser::Grammar::KeyValue.to_s == klass
        handle_key_value
        return
      end

      reset
      iterate_over
    end

    def complete_tree
      @wip_tree.tap do
        reset
        initialize
      end
    end

    private

    def determine_default_value klass
      @default_value = case klass
                       when TomlParser::Grammar::KeyOfArray.to_s then []
                       when TomlParser::Grammar::KeyNest.to_s,
                            TomlParser::Grammar::KeyOfHash.to_s then {}
                       end
    end

    def handle_key_value
      if @current.is_a? Hash
        @current.merge! @subject
      elsif @current.is_a? Array
        @current << @subject
        @current = @current.first
      end
    end

    def iterate_over
      if @subject.is_a? Array
        @subject.each do |key|
          @key = key
          set_current
        end
      else
        @key = @subject
        set_current
      end
      @key = nil
    end

    def reset
      @wip_tree.deep_merge!(@node) unless @node.nil? || @node.empty?
      @node = @current = {}
    end

    def set_current
      @current[ @key ] ||= @default_value.dup
      @current = @current[ @key ]
    end
  end
end
