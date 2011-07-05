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

Copyright (c) 2009-20011 Grzegorz Derebecki, released under the MIT license
