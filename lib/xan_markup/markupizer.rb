require 'xan_markup/tag'

module XanMarkup
  class Markupizer
    MarkupSyntax                = /\{\{ ?(.*?) ?\}\}/

    def initialize(content, syntax = MarkupSyntax)
      @content = content.to_s.dup.to_str
      @syntax = syntax
    end

    def tags
      @content.scan(@syntax).map do |markup|
        Tag.new(markup.first)
      end
    end

    def markupize
      @content.gsub(@syntax) do |markup|
        yield Tag.new($1)
      end
    end
  end
end
