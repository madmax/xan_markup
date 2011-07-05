module XanMarkup
  MarkupSyntax                = /\{\{ ?(.*?) ?\}\}/
  QuotedString                = /"[^"]+"|'[^']+'/
  QuotedFragment              = /#{QuotedString}|(?:[^\s,\|'"]|#{QuotedString})+/
  TagAttributes               = /(\w+)\s*\=\s*(#{QuotedFragment})/
  CleanAttributeValue         = /^("|')|("|')$/  
  module Helper
    def markupize(content)
      content.to_s.dup.gsub(MarkupSyntax) do |markup|
        args = {}
        method = "markup_#{$1.split.first}"
        $1.scan(TagAttributes) do |key, value|
          args[key.to_sym] = value.gsub(CleanAttributeValue, "")
        end
        (args.empty? ? send(method) : send(method, args)).to_s  if respond_to?(method)
      end
    end
  end
end
