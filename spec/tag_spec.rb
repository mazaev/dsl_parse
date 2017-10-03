require "spec_helper"

RSpec.describe DSLParse::Tag do

  let ( :tag_b_open ) { DSLParse::Tag.new( "[b]", 0 ) }
  let ( :tag_asterisk_close ) { DSLParse::Tag.new( "[/*]", 0 ) }
  let ( :tag_c_red_open ) { DSLParse::Tag.new( "[c red]", 0 ) }

  describe "check for '[b]', position: 0" do
    it "#name: ':bold'" do
      expect( tag_b_open.name ).to eq :bold
    end
    it "#status: ':open'" do
      expect( tag_b_open.status ).to eq :open
    end
    it "#position: 0" do
      expect( tag_b_open.position ).to eq 0
    end
    it "#mark: 'nil'" do
      expect( tag_b_open.mark ).to eq nil
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

end
