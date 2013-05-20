module XanMarkup
  class Tag
    QuotedString = /"[^"]+"|'[^']+'/
    QuotedFragment = /#{QuotedString}|(?:[^\s,\|'"]|#{QuotedString})+/
    TagArgs = /(\w+)\s*\=\s*(#{QuotedFragment})/
    CleanArgValue = /^("|')|("|')$/

    def initialize(tag)
      @tag = tag
    end

    def name
      @tag.split.first
    end

    def args
      {}.tap { |args| @tag.scan(TagArgs) { |key, value| args[key.to_sym] = value.gsub(CleanArgValue, "") } }
    end

    def args?
      args.size > 0
    end

    def method
      "markup_#{name}"
    end
  end
end
