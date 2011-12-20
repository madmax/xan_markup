module XanMarkup
  MarkupSyntax                = /\{\{ ?(.*?) ?\}\}/
  QuotedString                = /"[^"]+"|'[^']+'/
  QuotedFragment              = /#{QuotedString}|(?:[^\s,\|'"]|#{QuotedString})+/
  TagAttributes               = /(\w+)\s*\=\s*(#{QuotedFragment})/
  CleanAttributeValue         = /^("|')|("|')$/  
  module Helper
    def markupize(content)
      content.to_s.dup.gsub(MarkupSyntax) do |markup|
        args   = {}
        tag    = $1.split.first
        method = "markup_#{tag}"
        $1.scan(TagAttributes) do |key, value|
          args[key.to_sym] = value.gsub(CleanAttributeValue, "")
        end
        if respond_to?(method)
          (args.empty? ? send(method) : send(method, args)).to_s  
        else
          "missing tag: #{tag}"
        end
      end
    end
  end
end
