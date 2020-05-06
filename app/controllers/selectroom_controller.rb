class SelectroomController < ApplicationController
  before_action :authenticate_user!
  
  def index
    logger.debug("selectroom indexに入りました")
    logger.debug(params)
    
    logger.debug(current_user.name)
    
    # Userテーブルメンテ　24h以上前のログインアカウントを削除
    User.where('created_at <= ?', 24.hour.ago).delete_all
    
    # Roomテーブルメンテ　6h以上前のroomを削除 対象に
    rooms = Room.where(position: "owner").where('created_at <= ?', 6.hour.ago)

    if rooms.present?
      rooms.each do |room|
    
    		# 該当roomNumの村立てが２ｈ以内に行われていない場合
    		if Village.where(roomNum: room.roomNum).where('created_at >= ?', 2.hour.ago).blank?
    			# 該当のroomNumをRoomテーブルから削除する
    			Room.where(roomNum: room.roomNum).delete_all
    		end
    
      end
    end

    
  end
end
