# XanMarkup

Very simple tag parser

## Install & Example

Add to your Gemfile

    gem "xan_markup"

Create helper (call it like you want)

    module MarkupHelper
      include XanMarkup::Helper

      def markup_favorite_movie
        "Matrix"
      end
    end

In views use:

    <%= markupize("My favorite movie is {{ favorite_movie }}") %>

## Atributes

You can pass attributes to tags

    {{ favorite_movie genre="sf-fi" }}

    def markup_favorite_movie(hash_of_args)
      ....
    end


## Customization

You can write own class that will be called when tag is found.
For example using instance variables not helper methods:

    class MyCustomCaller
      def initialize(context)
        @context = context
      end

      def call
        ->(tag) do
            @context.instance_variable_get("@tag.name") || "missing tag: #{tag.name}"
          end
        end
      end
    end

    def markupize(content)
      Markupizer.new(content).markupize &MyCustomCaller.new(self).call
    end

You can change also syntax

    def markupize(content)
      Markupizer.new(content, /\[ ?(.*?) ?\]/).markupize &MyCustomCaller.new(self).call
    end

    @favorite_movie = "Matrix"
    markupize("My favorite movie is [favorite_movie]") #=> My favorite movie is Matrix

Copyright (c) 2009-20015 Grzegorz Derebecki, released under the MIT license
