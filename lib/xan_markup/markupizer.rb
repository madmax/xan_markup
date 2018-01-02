require 'xan_markup/tag'
require 'xan_markup/content_tag'

module XanMarkup
  class Markupizer
    MarkupSyntax                = /\{\{ ?(.*?) ?\}\}/
    BlockMarkupSyntax           = /\{\{ ?((\w+)(.*?)) ?\}\}(.*?)\{\{ ?\/(\2) ?\}\}/

    def initialize(content, syntax = MarkupSyntax, block_syntax = BlockMarkupSyntax)
      @content = content.to_s.dup.to_str
      @syntax = syntax
      @block_syntax = block_syntax
    end

    def tags
      tags = []
      markupize { |tag| tags << tag }
      tags
    end

    def markupize(content = @content, &block)
      content = markupize_syntax(@block_syntax, content, &block)
      markupize_syntax(@syntax, content, &block)
    end

    def markupize_syntax(syntax, content, &block)
      content.gsub(syntax) do |markup|
        if content = $4
          yield ContentTag.new($1, markupize(content, &block))
        else
          yield Tag.new($1)
        end
      end
    end
  end
end
