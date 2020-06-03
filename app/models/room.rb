class Room < ApplicationRecord

  def self.createRoomNum
    # roomNumのユニーク値算出
    max = Room.maximum(:roomNum)
    if max.nil?
    	roomNumOrd = 1
    else
    	roomNumOrd = max + 1
    end
    
    return roomNumOrd
  end
  

  # 表示向けデータ作成(一覧)
  def self.getRoomIndexText
    # return @roomNumSorted[] , @ownNameSorted[] , @memberTxtSorted[]
    
    @rooms = self.all
      
  	@roomNum = []
  	@ownName = []
  	@memberTxt = []

  	@rooms.each do |room|
  		if room.position == "owner"
  		  @roomNum.push(room.roomNum)
  		  @ownName.push(room.name)
  		  @memberTxt.push(nil)
  		end
  	end

  	@rooms.each do |room|
      if room.position == "member"
      
        # エラーケースへの自浄行動
        if @roomNum.index(room.roomNum).nil?
          logger.debug("★★エラー！！！memberは存在するが、ownerが存在しない　自浄作業が必要な状況")
          Room.where(id: room.id).delete_all
        else
          index = @roomNum.index(room.roomNum)
          # logger.debug("room.id=#{room.id}")
          # logger.debug("index=#{index}")
          # logger.debug("@memberTxt=#{@memberTxt}")
          
          if @memberTxt[index] == nil
            @memberTxt[index] = room.name
          else
            @memberTxt[index] = @memberTxt[index] + "," + room.name
          end  		    
          
        end
      end
  	end
  	
  	logger.debug("@roomNum = #{@roomNum}")
  	logger.debug("@ownName = #{@ownName}")
  	logger.debug("@memberTxt = #{@memberTxt}")
    	
    #　配列順序　降順へ
    @roomNumSorted = @roomNum.sort.reverse!
    @roomNumSortedIndex = []
    @ownNameSorted = []
    @memberTxtSorted = []
    
    @roomNumSorted.each do |num|
    	@roomNum.each_with_index do |target , i|
    		if target == num
    			@roomNumSortedIndex.push(i)
    		end
    	end
    end
    
    # puts "@roomNum: #{@roomNum}"
    # puts "@roomNumSorted: #{@roomNumSorted}"
    # puts "@roomNumSortedIndex: #{@roomNumSortedIndex}"
    
    @roomNumSortedIndex.each do |index|
        @ownNameSorted.push(@ownName[index])
        @memberTxtSorted.push(@memberTxt[index])
    end
    
    # puts "@roomNumSorted: #{@roomNumSorted}"
    # puts "@ownNameSorted: #{@ownNameSorted}"
    # puts "@memberTxtSorted: #{@memberTxtSorted}"


  	return @roomNumSorted , @ownNameSorted , @memberTxtSorted
      
  end

  # 表示向けデータ作成(部屋個別)
  def self.getRoomShowText(roomNum)
    # return @showRoomNum,@showOwnName,@showMemberTxt[],@showVilList[],@showMemList[],@showOwnData

    @rooms = self.where(roomNum: roomNum)
      
  	@showRoomNum = ""
  	@showOwnName = ""
  	@showMemberTxt = []
  	@showVilList = []
  	@showMemList = []
  	@showOwnData = ""

  	@rooms.each do |room|
  		if room.position == "owner"
  		  @showRoomNum = room.roomNum
  		  @showOwnName = room.name
  		  @showOwnData = { name: room.name, email: room.email}
  		else # memberの場合
  		  @showMemberTxt.push(room.name)
  		  @showMemList.push({ name: room.name, email: room.email})
  		end
  		@showVilList.push({ name: room.name, email: room.email})
  	end

    return @showRoomNum,@showOwnName,@showMemberTxt,@showVilList,@showMemList,@showOwnData
  end
  
  
end
