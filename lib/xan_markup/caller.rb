module XanMarkup
  class Caller
    def initialize(context)
      @context = context
    end

    def call
      ->(tag) do
        if @context.respond_to?(tag.method)
          @context.send(tag.method, tag.args)
        else
          "missing tag: #{tag.name}"
        end
      end
    end
  end
end
