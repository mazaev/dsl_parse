module DSLParse

  def self.get_tag str
    str[ str =~ /(?<!\\)\[/ .. str =~ /(?<!\\)\]/ ]
  end
  
end
