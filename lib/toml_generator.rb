require 'deep_merge'
require_relative 'toml_grammar'

class TomlGenerator

  def initialize
    @wip_tree = {}
    @node = @current = nil
  end

  def add parsed_line
    case parsed_line.class.to_s
    when TomlGrammar::KeyNest.to_s then
      new_node
      parsed_line.value.each do |key|
        @current[ key ] ||= {}
        @current = @current[ key ]
      end
    when TomlGrammar::KeyOfHash.to_s then
      new_node
      key = parsed_line.value
      @current[ key ] ||= {}
      @current = @current[ key ]
    when TomlGrammar::KeyOfArray.to_s then
      new_node
      key = parsed_line.value
      @current[ key ] ||= []
      @current = @current[ key ]
    when TomlGrammar::KeyValue.to_s then
      if @current.is_a? Hash
        @current.merge! parsed_line.value
      elsif @current.is_a? Array
        @current << parsed_line.value
        @current = @current.first
      end
    end
  end

  def complete_tree
    @wip_tree.tap do
      new_node
      initialize
    end
  end

  private

  def new_node
    @wip_tree.deep_merge!(@node) unless @node.nil? || @node.empty?
    @node = @current = {}
  end

end
