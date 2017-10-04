module DSLParse

  Colors = [:aliceblue, :antiquewhite, :aqua, :aquamarine, :azure, :beige, :bisque, :blanchedalmond, :blue, :blueviolet, :brown, :burlywood, :cadetblue, :chartreuse, :chocolate, :coral, :cornflowerblue, :cornsilk, :crimson, :cyan, :darkblue, :darkcyan, :darkgoldenrod, :darkgray, :darkgreen, :darkkhaki, :darkmagenta, :darkolivegreen, :darkorange, :darkorchid, :darkred, :darksalmon, :darkseagreen, :darkslateblue, :darkslategray, :darkturquoise, :darkviolet, :deeppink, :deepskyblue, :dimgray, :dodgerblue, :firebrick, :floralwhite, :forestgreen, :fuchsia, :gainsboro, :ghostwhite, :gold, :goldenrod, :gray, :green, :greenyellow, :honeydew, :hotpink, :indianred, :indigo, :ivory, :khaki, :lavender, :lavenderblush, :lawngreen, :lemonchiffon, :lightblue, :lightcoral, :lightcyan, :lightgoldenrodyellow, :lightgreen, :lightgrey, :lightpink, :lightsalmon, :lightseagreen, :lightskyblue, :lightslategray, :lightsteelblue, :lightyellow, :lime, :limegreen, :linen, :magenta, :maroon, :mediumaquamarine, :mediumblue, :mediumorchid, :mediumpurple, :mediumseagreen, :mediumslateblue, :mediumspringgreen, :mediumturquoise, :mediumvioletred, :midnightblue, :mintcream, :mistyrose, :moccasin, :navajowhite, :navy, :oldlace, :olive, :olivedrab, :orange, :orangered, :orchid, :palegoldenrod, :palegreen, :paleturquoise, :palevioletred, :papayawhip, :peachpuff, :peru, :pink, :plum, :powderblue, :purple, :red, :rosybrown, :royalblue, :saddlebrown, :salmon, :sandybrown, :seagreen, :seashell, :sienna, :silver, :skyblue, :slateblue, :slategray, :snow, :springgreen, :steelblue, :tan, :teal, :thistle, :tomato, :turquoise, :violet, :wheat, :white, :whitesmoke, :yellow, :yellowgreen]
  Languages = [:Afrikaans, :Basque, :Belarusian, :English, :French, :German, :GermanNewSpelling, :Chinese, :ChinesePRC, :Latin, :Polish, :Russian, :Swahili, :Turkish, :Ukrainian, "1033"] # 1033 <~ X3????
  ColorsRE = /#{ Colors.join( "|" ) }/
  MarginsRE = /m\d/
  LanguagesRE = /#{ Languages.join( "|" ) }/
  DictionariesRE = /\w+ \(..-..\)/

  DSLTags = [
    /\[b\]/,                              /\[\/b\]/,      # :bold
    /\[i\]/,                              /\[\/i\]/,      # :italic
    /\[u\]/,                              /\[\/u\]/,      # :underline
    /\[c\]|\[c #{ ColorsRE }\]/,          /\[\/c\]/,      # :color
    /\[\*\]/,                             /\[\/\*\]/,     # :asterisk
    /\[#{ MarginsRE }\]/,                 /\[\/m\]/,      # :margin
    /\[trn\]/,                            /\[\/trn\]/,    # :translation
    /\[ex\]/,                             /\[\/ex\]/,     # :example
    /\[com\]/,                            /\[\/com\]/,    # :comment
    /\[\!trs\]/,                          /\[\/\!trs\]/,  # :noindex
    /\[s\]/,                              /\[\/s\]/,      # :multimedia
    /\[url\]/,                            /\[\/url\]/,    # :url
    /\[p\]/,                              /\[\/p\]/,      # :lable
    /\['\]/,                              /\[\/'\]/,      # :accent
    /\[lang id=#{ LanguagesRE }\]/,       /\[\/lang\]/,   # :lang
    /\[ref dict="#{ DictionariesRE }"\]/, /\[\/ref\]/,    # :link
    /\[t\]/,                              /\[\/t\]/,      # :transcript
    /\[sup\]/,                            /\[\/sup\]/,    # :superscript
    /\[sub\]/,                            /\[\/sub\]/]    # :subscript

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
    lang:         {},
    link:         {},
    transcript:   {},
    superscript:  {},
    subscript:    {} 
  }

  TagStatus = [:open, :close]

  class Tag

    attr :name, :status, :position, :raw

    def initialize dsl_tag, position
      @raw = dsl_tag
      i = DSLTags.index { |v| v.match @raw }
      @name     = TagStack.keys[i/2]
      @status   = TagStatus[i%2]
      @position = position
    end
  end

  color_proc = proc { |val| { class: val.match( ColorsRE ).to_s } }
  margin_proc = proc { |val| { class: val.match( MarginsRE ).to_s } }
  lang_proc = proc { |val| { lang_id: val.match( LanguagesRE ).to_s } }
  link_proc = proc { |val| { dict: val.match( DictionariesRE ).to_s } }

  # puts color_proc.call( "[c green]")
  # puts margin_proc.call( "[m3]")
  # puts lang_proc.call( "[lang id=1033]" )
  # puts link_proc.call( "[ref dict=\"LingvoGrammar (En-Ru)\"]" )

  def self.separator str
    tags, s, tag, is_tag, is_esc = [], "", "", false, false
    str.each_char do |ch|
      case ch
      when "\\"
        is_esc = true; next        
      when "["
        is_tag = true unless is_esc
        unless is_tag
          s << ch
          is_esc = false
        end
      when "]"
        unless is_tag
          s << ch
          is_esc = false
        end
        is_tag = false unless is_esc
      else
        is_tag ? tag << ch : s << ch
      end
    end
    return "#{s}   #{tag}"
  end

  x = %q{[m1]1) [p]филос.[/p] [trn]схоластика [i][com](средневековая религиозная философия, соединявшая теолого-догматические предпосылки с рационалистической методикой и интересом к формально-логическим проблемам)[/com][/trn][/i][/m]}
  puts separator( %q([p]сущ.[/p][c];[/c] [p]книжн.[/p]) )
  puts separator( %q(\[[t]'skəulɪə[/t]\]) )
  puts separator( x )
end




















