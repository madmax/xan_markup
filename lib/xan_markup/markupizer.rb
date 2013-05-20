require 'xan_markup/tag'

module XanMarkup
  class Markupizer
    MarkupSyntax                = /\{\{ ?(.*?) ?\}\}/

    def initialize(content)
      @content = content.to_s.dup.to_str
    end

    def tags
      @content.scan(MarkupSyntax).map do |markup|
        Tag.new(markup.first)
      end
    end

    def markupize
      @content.gsub(MarkupSyntax) do |markup|
        yield Tag.new($1)
      end
    end
  end
end
