require "spec_helper"

RSpec.describe DSLParse::Tag do

  let ( :tag_accent_open ) { DSLParse::Tag.new( "[']", 0 ) }
  let ( :tag_asterisk_close ) { DSLParse::Tag.new( "[/*]", 0 ) }
  let ( :tag_m1_open ) { DSLParse::Tag.new( "[m1]", 0 ) }
  let ( :tag_c_red_open ) { DSLParse::Tag.new( "[c red]", 0 ) }
  let ( :tag_lang_latin_open ) { DSLParse::Tag.new( "[lang id=Latin]", 0 ) }
  let ( :tag_link_open ) { DSLParse::Tag.new( "[ref dict=\"LingvoGrammar (En-Ru)\"]", 0 ) }

  describe "check for '[']', position: 0" do
    it "#name: ':accent'" do
      expect( tag_accent_open.name ).to eq :accent
    end
    it "#status: ':open'" do
      expect( tag_accent_open.status ).to eq :open
    end
    it "#position: 0" do
      expect( tag_accent_open.position ).to eq 0
    end
  end

  describe "check for '[/*]', position: 0" do
    it "#name: ':asterisk'" do
      expect( tag_asterisk_close.name ).to eq :asterisk
    end
    it "#status: ':close'" do
      expect( tag_asterisk_close.status ).to eq :close
    end
    it "#position: 0" do
      expect( tag_asterisk_close.position ).to eq 0
    end
  end

  describe "check for '[c red]', position: 0" do
    it "#name: ':color'" do
      expect( tag_c_red_open.name ).to eq :color
    end
    it "#status: ':close'" do
      expect( tag_c_red_open.status ).to eq :open
    end
    it "#position: 0" do
      expect( tag_c_red_open.position ).to eq 0
    end
  end

  describe "check for '[m1]', position: 0" do
    it "#name: ':margin'" do
      expect( tag_m1_open.name ).to eq :margin
    end
    it "#status: ':open'" do
      expect( tag_m1_open.status ).to eq :open
    end
    it "#position: 0" do
      expect( tag_m1_open.position ).to eq 0
    end
  end

  describe "check for '[lang id=Latin]', position: 0" do
    it "#name: ':lang'" do
      expect( tag_lang_latin_open.name ).to eq :lang
    end
    it "#status: ':open'" do
      expect( tag_lang_latin_open.status ).to eq :open
    end
    it "#position: 0" do
      expect( tag_lang_latin_open.position ).to eq 0
    end
  end

  describe "check for '[ref dict=\"LingvoGrammar (En-Ru)\"]', position: 0" do
    it "#name: ':link'" do
      expect( tag_link_open.name ).to eq :link
    end
    it "#status: ':open'" do
      expect( tag_link_open.status ).to eq :open
    end
    it "#position: 0" do
      expect( tag_link_open.position ).to eq 0
    end
  end

end
