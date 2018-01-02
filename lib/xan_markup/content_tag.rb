module XanMarkup
  class ContentTag < Tag
    attr_reader :content
    def initialize(tag, content)
      @tag = tag
      @content = content
    end

    def args
      super.merge(content: content)
    end
  end
end
