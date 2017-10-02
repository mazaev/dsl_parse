require "spec_helper"

RSpec.describe DSLParse do

  let( :simple_tag ) { %q{[p]прил.[/p]} }
  let( :esc_chs_tag ) { %q{\[[t]ə'sɪdjuləs[/t]\]} }
  let( :color_tag ) { %q{[p][trn]прил.[/p][c green];[/c] [p]физиол.[/trn][/p]} }
  let( :hard_str ) { %q{[m2][*][ex][lang id=1033]acidulous satire[/lang] — острая сатира[/ex][/*][/m]} }

  describe "finding tags:" do
    it "[p]" do
      expect( DSLParse::get_tag simple_tag ).to eq "[p]"
    end
    it "[t]" do
      expect( DSLParse::get_tag esc_chs_tag ).to eq "[t]"
    end
    it "[m2]" do
      expect( DSLParse::get_tag hard_str ).to eq "[m2]"
    end
  end

  describe "to identify tag" do
  end
end
