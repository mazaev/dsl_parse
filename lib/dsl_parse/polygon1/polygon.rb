require "nokogiri"
module DSLParse

  Colors = [:aliceblue, :antiquewhite, :aqua, :aquamarine, :azure, :beige, :bisque, :blanchedalmond, :blue, :blueviolet, :brown, :burlywood, :cadetblue, :chartreuse, :chocolate, :coral, :cornflowerblue, :cornsilk, :crimson, :cyan, :darkblue, :darkcyan, :darkgoldenrod, :darkgray, :darkgreen, :darkkhaki, :darkmagenta, :darkolivegreen, :darkorange, :darkorchid, :darkred, :darksalmon, :darkseagreen, :darkslateblue, :darkslategray, :darkturquoise, :darkviolet, :deeppink, :deepskyblue, :dimgray, :dodgerblue, :firebrick, :floralwhite, :forestgreen, :fuchsia, :gainsboro, :ghostwhite, :gold, :goldenrod, :gray, :green, :greenyellow, :honeydew, :hotpink, :indianred, :indigo, :ivory, :khaki, :lavender, :lavenderblush, :lawngreen, :lemonchiffon, :lightblue, :lightcoral, :lightcyan, :lightgoldenrodyellow, :lightgreen, :lightgrey, :lightpink, :lightsalmon, :lightseagreen, :lightskyblue, :lightslategray, :lightsteelblue, :lightyellow, :lime, :limegreen, :linen, :magenta, :maroon, :mediumaquamarine, :mediumblue, :mediumorchid, :mediumpurple, :mediumseagreen, :mediumslateblue, :mediumspringgreen, :mediumturquoise, :mediumvioletred, :midnightblue, :mintcream, :mistyrose, :moccasin, :navajowhite, :navy, :oldlace, :olive, :olivedrab, :orange, :orangered, :orchid, :palegoldenrod, :palegreen, :paleturquoise, :palevioletred, :papayawhip, :peachpuff, :peru, :pink, :plum, :powderblue, :purple, :red, :rosybrown, :royalblue, :saddlebrown, :salmon, :sandybrown, :seagreen, :seashell, :sienna, :silver, :skyblue, :slateblue, :slategray, :snow, :springgreen, :steelblue, :tan, :teal, :thistle, :tomato, :turquoise, :violet, :wheat, :white, :whitesmoke, :yellow, :yellowgreen]

  # TagStack = {
  #   bold: { open: /\[b\]/, close: /\[\/b\]/ },
  #   italic: { open: /\[i\]/, close: /\[\/i\]/ },
  #   underline: { open: /\[u\]/, close: /\[\/u\]/ },
  #   color: { open: /\[c\]/, close: /\[\/c\]/ },
  #   asterisk: { open: /\[*\]/, close: /\[\/*\]/ },
  #   margin: { open: /\[mX\]/, close: /\[\/m\]/ },
  #   translation: { open: /\[trn\]/, close: /\[\/trn\]/ },
  #   example: { open: /\[ex\]/, close: /\[\/ex\]/ },
  #   comment: { open: /\[com\]/, close: /\[\/com\]/ },
  #   noindex: { open: /\[!trs\]/, close: /\[\/!trs\]/ },
  #   multimedia: { open: /\[s\]/, close: /\[\/s\]/ },
  #   url: { open: /\[url\]/, close: /\[\/url\]/ },
  #   lable: { open: /\[p\]/, close: /\[\/p\]/ },
  #   accent: { open: /\['\]/, close: /\[\/'\]/ },
  #   lamg: { open: /\[lang\]/, close: /\[\/lang\]/ },
  #   link: { open: /\[ref\]/, close: /\[\/ref\]/ },
  #   transcript: { open: /\[t\]/, close: /\[\/t\]/ },
  #   superscript: { open: /\[sup\]/, close: /\[\/sup\]/ },
  #   subscript: { open: /\[sub\]/, close: /\[\/sub\]/ } 
  # }

  # TagStack = {
  #   bold:         { dsl: [/\[b\]/, /\[\/b\]/] },
  #   italic:       { dsl: [/\[i\]/, /\[\/i\]/] },
  #   underline:    { dsl: [/\[u\]/, /\[\/u\]/] },
  #   color:        { dsl: [/\[c\]/, /\[\/c\]/] },
  #   asterisk:     { dsl: [/\[\*\]/, /\[\/\*\]/] },
  #   margin:       { dsl: [/\[mX\]/, /\[\/m\]/] },
  #   translation:  { dsl: [/\[trn\]/, /\[\/trn\]/] },
  #   example:      { dsl: [/\[ex\]/, /\[\/ex\]/] },
  #   comment:      { dsl: [/\[com\]/, /\[\/com\]/] },
  #   noindex:      { dsl: [/\[\!trs\]/, /\[\/\!trs\]/] },
  #   multimedia:   { dsl: [/\[s\]/, /\[\/s\]/] },
  #   url:          { dsl: [/\[url\]/, /\[\/url\]/] },
  #   lable:        { dsl: [/\[p\]/, /\[\/p\]/] },
  #   accent:       { dsl: [/\[\'\]/, /\[\/\'\]/] },
  #   lamg:         { dsl: [/\[lang\]/, /\[\/lang\]/] },
  #   link:         { dsl: [/\[ref\]/, /\[\/ref\]/] },
  #   transcript:   { dsl: [/\[t\]/, /\[\/t\]/] },
  #   superscript:  { dsl: [/\[sup\]/, /\[\/sup\]/] },
  #   subscript:    { dsl: [/\[sub\]/, /\[\/sub\]/] } 
  # }

  DSLTags = [
    /\[b\]/,      /\[\/b\]/,
    /\[i\]/,      /\[\/i\]/,
    /\[u\]/,      /\[\/u\]/,
    /\[c\]/,      /\[\/c\]/,
    /\[\*\]/,     /\[\/\*\]/,
    /\[mX\]/,     /\[\/m\]/,
    /\[trn\]/,    /\[\/trn\]/,
    /\[ex\]/,     /\[\/ex\]/,
    /\[com\]/,    /\[\/com\]/,
    /\[\!trs\]/,  /\[\/\!trs\]/,
    /\[s\]/,      /\[\/s\]/,
    /\[url\]/,    /\[\/url\]/,
    /\[p\]/,      /\[\/p\]/,
    /\[\'\]/,     /\[\/\'\]/,
    /\[lang\]/,   /\[\/lang\]/,
    /\[ref\]/,    /\[\/ref\]/,
    /\[t\]/,      /\[\/t\]/,
    /\[sup\]/,    /\[\/sup\]/,
    /\[sub\]/,    /\[\/sub\]/
  ]


  def self.get_tag str
    str[ str =~ /(?<!\\)\[/ .. str =~ /(?<!\\)\]/ ]
  end

  s = %q{\[[t]ə'sɪdjuləs[/t]\]}

  class Tag
    attr :name, :kind
    def initialize tag
      @name = tag
    end
  end

  t = Tag.new "[t]"

  s = "[com]"


  puts DSLTags.inspect
  

end


















