require "nokogiri"
module DSLParse

  Colors = [:aliceblue, :antiquewhite, :aqua, :aquamarine, :azure, :beige, :bisque, :blanchedalmond, :blue, :blueviolet, :brown, :burlywood, :cadetblue, :chartreuse, :chocolate, :coral, :cornflowerblue, :cornsilk, :crimson, :cyan, :darkblue, :darkcyan, :darkgoldenrod, :darkgray, :darkgreen, :darkkhaki, :darkmagenta, :darkolivegreen, :darkorange, :darkorchid, :darkred, :darksalmon, :darkseagreen, :darkslateblue, :darkslategray, :darkturquoise, :darkviolet, :deeppink, :deepskyblue, :dimgray, :dodgerblue, :firebrick, :floralwhite, :forestgreen, :fuchsia, :gainsboro, :ghostwhite, :gold, :goldenrod, :gray, :green, :greenyellow, :honeydew, :hotpink, :indianred, :indigo, :ivory, :khaki, :lavender, :lavenderblush, :lawngreen, :lemonchiffon, :lightblue, :lightcoral, :lightcyan, :lightgoldenrodyellow, :lightgreen, :lightgrey, :lightpink, :lightsalmon, :lightseagreen, :lightskyblue, :lightslategray, :lightsteelblue, :lightyellow, :lime, :limegreen, :linen, :magenta, :maroon, :mediumaquamarine, :mediumblue, :mediumorchid, :mediumpurple, :mediumseagreen, :mediumslateblue, :mediumspringgreen, :mediumturquoise, :mediumvioletred, :midnightblue, :mintcream, :mistyrose, :moccasin, :navajowhite, :navy, :oldlace, :olive, :olivedrab, :orange, :orangered, :orchid, :palegoldenrod, :palegreen, :paleturquoise, :palevioletred, :papayawhip, :peachpuff, :peru, :pink, :plum, :powderblue, :purple, :red, :rosybrown, :royalblue, :saddlebrown, :salmon, :sandybrown, :seagreen, :seashell, :sienna, :silver, :skyblue, :slateblue, :slategray, :snow, :springgreen, :steelblue, :tan, :teal, :thistle, :tomato, :turquoise, :violet, :wheat, :white, :whitesmoke, :yellow, :yellowgreen]
  Languages = [:Afrikaans, :Basque, :Belarusian, :English, :French, :German, :GermanNewSpelling, :Chinese, :ChinesePRC, :Latin, :Polish, :Russian, :Swahili, :Turkish, :Ukrainian, "1033"] # 1033 <~ X3????
  ColorsRE = /#{ Colors.join( "|" ) }/
  # MarginsRE = /m[1-9]/
  LanguagesRE = /#{ Languages.join( "|" ) }/
  DictionariesRE = /\w+ \(..-..\)/

  DSLTags = [
    "b",    "/b",      # :bold
    "i",    "/i",      # :italic
    "u",    "/u",      # :underline
    "c",    "/c",      # :color +attr
    "*",    "/*",      # :asterisk
    "m0",   "/m",      # :margin
    "m1",   "/m",      # :margin_1
    "m2",   "/m",      # :margin_2
    "m3",   "/m",      # :margin_3
    "m4",   "/m",      # :margin_4
    "m5",   "/m",      # :margin_5
    "m6",   "/m",      # :margin_6
    "m7",   "/m",      # :margin_7
    "m8",   "/m",      # :margin_8
    "m9",   "/m",      # :margin_9
    "trn",  "/trn",    # :translation
    "ex",   "/ex",     # :example
    "com",  "/com",    # :comment
    "!trs", "/!trs",   # :noindex
    "s",    "/s",      # :multimedia
    "url",  "/url",    # :url
    "p",    "/p",      # :lable
    "'",    "/'",      # :accent
    "lang", "/lang",   # :lang +attr
    "ref",  "/ref",    # :link +attr
    "t",    "/t",      # :transcript
    "sup",  "/sup",    # :superscript
    "sub",  "/sub"]    # :subscript

  # DSLTags = [
  #   /^b$/,                              /^\/b$/,      # :bold
  #   /^i$/,                              /^\/i$/,      # :italic
  #   /^u$/,                              /^\/u$/,      # :underline
  #   /^c$|^c #{ ColorsRE }$/,            /^\/c$/,      # :color
  #   /^\*$/,                             /^\/\*$/,     # :asterisk
  #   /^#{ MarginsRE }$/,                 /^\/m$/,      # :margin
  #   /^trn$/,                            /^\/trn$/,    # :translation
  #   /^ex$/,                             /^\/ex$/,     # :example
  #   /^com$/,                            /^\/com$/,    # :comment
  #   /^\!trs$/,                          /^\/\!trs$/,  # :noindex
  #   /^s$/,                              /^\/s$/,      # :multimedia
  #   /^url$/,                            /^\/url$/,    # :url
  #   /^p$/,                              /^\/p$/,      # :lable
  #   /^'$/,                              /^\/'$/,      # :accent
  #   /^lang id=#{ LanguagesRE }$/,       /^\/lang$/,   # :lang
  #   /^ref dict="#{ DictionariesRE }"$/, /^\/ref$/,    # :link
  #   /^t$/,                              /^\/t$/,      # :transcript
  #   /^sup$/,                            /^\/sup$/,    # :superscript
  #   /^sub$/,                            /^\/sub$/]    # :subscript

  TagStack = {
    bold:         [:b],
    italic:       [:i],
    underline:    [:u],
    color:        [],
    asterisk:     {},
    margin:       {},
    margin_1:     {},
    margin_2:     {},
    margin_3:     {},
    margin_4:     {},
    margin_5:     {},
    margin_6:     {},
    margin_7:     {},
    margin_8:     {},
    margin_9:     {},
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

  class TagError < StandardError
    def initialize tag = "" 
      msg = "DSL tag: '#{tag}' not valid."
      super
    end
  end

  class Tag
    attr :name, :status, :position, :raw
    def initialize dsl_tag, position
      i = DSLTags.index { |v| v.match dsl_tag }
      unless i
        @raw = dsl_tag
        @name     = TagStack.keys[i/2]
        @status   = TagStatus[i%2]
        @position = position
      else
        # raise TagError( dsl_tag )
      end
    end
  end

  color_proc = lambda { |val| { class: val.match( ColorsRE ).to_s } }
  margin_proc = lambda { |val| { class: val.match( MarginsRE ).to_s } }
  lang_proc = lambda { |val| { lang_id: val.match( LanguagesRE ).to_s } }
  link_proc = lambda { |val| { dict: val.match( DictionariesRE ).to_s } }

  # puts color_proc.call( "green")
  # puts margin_proc.call( "[m3]")
  # puts lang_proc.call( "[lang id=1033]" )
  # puts link_proc.call( "[ref dict=\"LingvoGrammar (En-Ru)\"]" )

  def self.split mixline
    tags, line, tag, is_tag, is_esc = [], "", "", false, false
    mixline.each_char do |ch|
      case ch
        when "\\"
          is_esc = true
          next        
        when "["
          if is_esc
            line << ch
            is_esc = false
          else is_tag = true end
        when "]"
          if is_esc
            line << ch
            is_esc = false
          else
            is_tag = false

            true_tag, attr_tag = *tag.split(" ", 2)
            id_tag = DSLTags.index true_tag
            if !id_tag  # not valid tag
              raise TagError.new tag
            elsif (id_tag % 2) == 0 # open tag
              tags << [tag.dup, line.length]
            elsif (id_tag % 2) == 1 # clode tag
              tags.reverse_each do |x|
                if (x[0] == tag.slice(1)) && (x[2] == nil)
                  x << line.length
                  break
                end
              end
            end
            tag.clear

          end
        else is_tag ? tag << ch : line << ch
      end
    end
    return { tags: tags, line: line }
  end

  def self.transform tags
    result = []
    while not tags.empty?
      element = tags.slice!(0, 2)
      counter = 0
      opn_tag = element[0]
      cls_tag = DSLTags[DSLTags.index(opn_tag).next]
      tags.each_slice(2).with_index do |(tag, pos), idx|
        if tag == opn_tag
          counter =+ 1
          next
        elsif tag == cls_tag
          if counter > 0
            counter =- 1
          else
            element << pos
            tags.slice!(idx*2, 2)
            break
          end
        end
        # raise "Ошибка несоответствие тегов!!!"
      end
      result << element
      end
    return tags = result.dup
  end



  x = %q{[m1]1) [p2]филос.[/p] [trn]схоластика [i][com](средневековая религиозная философия, соединявшая теолого-догматические предпосылки с рационалистической методикой и интересом к формально-логическим проблемам)[/com][/trn][/i][/m]}
  x2 = %q{[m2][*][ex][lang id=1033]We managed to obtain another pin of beer.[/lang] — Нам удалось приобрести ещё один бочонок пива.[/ex][/*][/m]}
  # puts split( %q([p]сущ.[/p][c];[/c] [p]книжн.[/p]) ).inspect
  # puts split( %q(\[[t]'skəulɪə[/t]\]) )
  
  v = split( x )
  puts v[:tags].inspect
  puts v[:line]
  # puts (transform v[:tags]).inspect
  # puts (transform ["m2", 0, "m2", 0, "*", 0, "ex", 0, "lang id=1033", 0, "/lang", 41, "/ex", 89, "/*", 89, "/m", 77, "/m", 89]).inspect
  # puts v[:line][10..181]

  # def self.add_info dsl_tags
    
  #   i = DSLTags.index { |val| v.match dsl_tag }
  #   unless i raise "DSL tag '#{ dsl_tag }' not found."
  #   name = TagStack.keys[i/2]
  #   status = TagStatus[i%2]
  # end

  xml =  Nokogiri::XML::Builder.new

  arr = [:div, { class: "m1" }, "margin class"]

  xml.root{
    xml.send( *arr ) do
      xml.send(:zxc, "second")
    end
  }
  # puts xml.to_xml

end



















