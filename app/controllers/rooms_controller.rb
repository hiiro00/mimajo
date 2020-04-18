class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    logger.debug("createに入りました")
    logger.debug(params)

  	@room = Room.new(email:params[:email],name:params[:name],position:"owner",roomNum: Room.createRoomNum)
  	@room.save
  	redirect_to @room
  end




  def index
    # roomDBの異常値チェック
    # roomNum:Nilがあった場合は削除
    Room.where(roomNum: nil).delete_all

    @roomNum = []
    @ownName = []
    @memberTxt = []
    
    @roomNum,@ownName,@memberTxt = Room.getRoomIndexText

  end
  
  def join
    logger.debug("joinに入りました")
    logger.debug(params)
    
    # 参加した部屋がない場合
    if Room.where(roomNum: params[:roomNum]).blank?
      redirect_to action: 'index'
      return
    end
    
    
    # 存在しない場合は、追加する
    if Room.where(email: params[:email]).where(roomNum: params[:roomNum]).blank?
      @room = Room.new(name: params[:name],email: params[:email],position:"member",roomNum: params[:roomNum])
      
    	@room.save
    else # すでに存在する場合は追加しない
      @roomTmp = Room.where(email: params[:email]).where(roomNum: params[:roomNum])
      @room = @roomTmp[0]
    end
    
    if @room.position == "member"
      # ChatChannel.broadcast_to('message', {"message"=>"room_controlle_join", "roomNum"=>params[:roomNum], "name"=>params[:name],  "action"=>"join_room"})
    end
    
  	redirect_to @room
  end


    

  def show
    logger.debug("rooms#showに入りました")
    logger.debug(params)
    
    @room = Room.find(params[:id])

    @showRoomNum,@showOwnName,@showMemberTxtAry = Room.getRoomShowText(@room.roomNum)
    
    logger.debug("@showMemberTxt:")
    logger.debug(@showMemberTxt)
    

  end
    
    
end
