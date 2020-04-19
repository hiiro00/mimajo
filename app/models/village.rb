class Village < ApplicationRecord

  def self.createVillageNum
    # villageNumのユニーク値算出
    max = Village.maximum(:villageNum)
    if max.nil?
    	villageNumOrd = 1
    else
    	villageNumOrd = max + 1
    end
    
    return villageNumOrd
  end

end
