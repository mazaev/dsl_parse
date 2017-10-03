module DSLParse

  Colors = [:aliceblue, :antiquewhite, :aqua, :aquamarine, :azure, :beige, :bisque, :blanchedalmond, :blue, :blueviolet, :brown, :burlywood, :cadetblue, :chartreuse, :chocolate, :coral, :cornflowerblue, :cornsilk, :crimson, :cyan, :darkblue, :darkcyan, :darkgoldenrod, :darkgray, :darkgreen, :darkkhaki, :darkmagenta, :darkolivegreen, :darkorange, :darkorchid, :darkred, :darksalmon, :darkseagreen, :darkslateblue, :darkslategray, :darkturquoise, :darkviolet, :deeppink, :deepskyblue, :dimgray, :dodgerblue, :firebrick, :floralwhite, :forestgreen, :fuchsia, :gainsboro, :ghostwhite, :gold, :goldenrod, :gray, :green, :greenyellow, :honeydew, :hotpink, :indianred, :indigo, :ivory, :khaki, :lavender, :lavenderblush, :lawngreen, :lemonchiffon, :lightblue, :lightcoral, :lightcyan, :lightgoldenrodyellow, :lightgreen, :lightgrey, :lightpink, :lightsalmon, :lightseagreen, :lightskyblue, :lightslategray, :lightsteelblue, :lightyellow, :lime, :limegreen, :linen, :magenta, :maroon, :mediumaquamarine, :mediumblue, :mediumorchid, :mediumpurple, :mediumseagreen, :mediumslateblue, :mediumspringgreen, :mediumturquoise, :mediumvioletred, :midnightblue, :mintcream, :mistyrose, :moccasin, :navajowhite, :navy, :oldlace, :olive, :olivedrab, :orange, :orangered, :orchid, :palegoldenrod, :palegreen, :paleturquoise, :palevioletred, :papayawhip, :peachpuff, :peru, :pink, :plum, :powderblue, :purple, :red, :rosybrown, :royalblue, :saddlebrown, :salmon, :sandybrown, :seagreen, :seashell, :sienna, :silver, :skyblue, :slateblue, :slategray, :snow, :springgreen, :steelblue, :tan, :teal, :thistle, :tomato, :turquoise, :violet, :wheat, :white, :whitesmoke, :yellow, :yellowgreen]

  ColorsRE = Colors.join( "|" )

  DSLTags = [
    /\[b\]/,                          /\[\/b\]/,      # :bold
    /\[i\]/,                          /\[\/i\]/,      # :italic
    /\[u\]/,                          /\[\/u\]/,      # :underline
    /\[c\]|\[c (#{ ColorsRE })\]/,    /\[\/c\]/,      # :color
    /\[\*\]/,                         /\[\/\*\]/,     # :asterisk
    /\[mX\]/,                         /\[\/m\]/,      # :margin
    /\[trn\]/,                        /\[\/trn\]/,    # :translation
    /\[ex\]/,                         /\[\/ex\]/,     # :example
    /\[com\]/,                        /\[\/com\]/,    # :comment
    /\[\!trs\]/,                      /\[\/\!trs\]/,  # :noindex
    /\[s\]/,                          /\[\/s\]/,      # :multimedia
    /\[url\]/,                        /\[\/url\]/,    # :url
    /\[p\]/,                          /\[\/p\]/,      # :lable
    /\[\'\]/,                         /\[\/\'\]/,     # :accent
    /\[lang\]/,                       /\[\/lang\]/,   # :lamg
    /\[ref\]/,                        /\[\/ref\]/,    # :link
    /\[t\]/,                          /\[\/t\]/,      # :transcript
    /\[sup\]/,                        /\[\/sup\]/,    # :superscript
    /\[sub\]/,                        /\[\/sub\]/     # :subscript
  ]

  TagStack = {
    bold:         {},
    italic:       {},
    underline:    {},
    color:        {},
    asterisk:     {},
    margin:       {},
    translation:  {},
    example:      {},
    comment:      {},
    noindex:      {},
    multimedia:   {},
    url:          {},
    lable:        {},
    accent:       {},
    lamg:         {},
    link:         {},
    transcript:   {},
    superscript:  {},
    subscript:    {} 
  }

  TagStatus = [:open, :close]

  class Tag

    attr :name, :status, :position, :mark

    def initialize name, position
      i = DSLTags.index { |v| v.match name }
      @name     = TagStack.keys[i/2]
      @status   = TagStatus[i%2]
      @position = position
      @mark     = name.split.last if name
    end
  end

end

