class VillagesController < ApplicationController
  before_action :authenticate_user!

  def create
    logger.debug("Village#createに入りました")
    logger.debug(params)
    
    # 村テーブルメンテ　24h以上前の村を削除
    Village.where('created_at <= ?', 24.hour.ago).delete_all
    
    # villageNumのユニーク値算出
    villageNumOrd = Village.createVillageNum
    
    # お題　作成
    @theme = Theme.where( 'id >= ?', rand(Theme.first.id..Theme.last.id) ).first.content
    
    ## 村　配役構築
    # 村メンバー算出
    @showRoomNum,@showOwnName,@showMemberTxt,@showVilListAry = Room.getRoomShowText(params[:roomNum].to_i)

    # 村作成条件　チェック  村１名、オーナーのみ、メンバー０名を許容するため、以下コード非対象
    # if @showMemberTxt.blank?
    #   logger.debug("メンバー０名で作成できず")
    #   # prm = "$('#modal_err_createVlg_lackmember').modal('show')"
    #   # render :js => prm
    #   # render "rooms/show"
      
    #   # pram2 = "window.location = '$('#modal_err_createVlg_lackmember').modal('show')'"
    #   # render :js => pram2
    #   #render js: "alert('Hello Rails');"
      
    #   # ChatChannel.broadcast_to('message', {"message"=>"err_createVlg_lackmember", "roomNum"=>params[:roomNum], "action"=>"err_createVlg_lackmember"})
    #   return
    # end
    
    # 村メンバー
    logger.debug("村メンバー：")
    logger.debug(@showVilListAry)

    # GM役、内通者役の配列番号　抽選
    max = @showVilListAry.count
    gmnaituu = (0..(max-1)).to_a.sort_by{rand}[0..1]

    # 	４人     マイノリティ*１、他マジョリティ
    # 	５～６人   マイノリティ*１、ストーカー*１、他マジョリティ
    # 	７～１０人  マイノリティ*１、ストーカー*１、インフルエンサー*１、他マジョリティ
    # 	１１人以上  マイノリティ*１、ストーカー*２、インフルエンサー*１、他マジョリティ

    # 人数別配役　配置
    if max <= 1     # 	１人     マイノリティ　特殊な許容
      rnd = rand(4)
      case rnd
      when 0
        position = "マイノリティ"
      when 1
        position = "ストーカー"
      when 2
        position = "インフルエンサー"
      else
        position = "マジョリティ"
      end
        
      @village = Village.new(roomNum: params[:roomNum] , villageNum: villageNumOrd , name: @showVilListAry[0][:name] , email: @showVilListAry[0][:email] , position: position , theme: @theme)
      @village.save

    elsif max <= 4     # 	４人     マイノリティ*１、他マジョリティ
      @showVilListAry.each_with_index do |village , i|
        if i == gmnaituu[0]
          position = "マイノリティ"
        else
          position = "マジョリティ"
        end
        @village = Village.new(roomNum: params[:roomNum] , villageNum: villageNumOrd , name: @showVilListAry[0][:name] , email: @showVilListAry[0][:email] , position: position , theme: @theme)
        @village.save
      end

    elsif max <= 6  # 	５～６人   マイノリティ*１、ストーカー*１、他マジョリティ
      @showVilListAry.each_with_index do |village , i|
        if i == gmnaituu[0]
          position = "マイノリティ"
        elsif i == gmnaituu[1] 
          position = "ストーカー"
        else
          position = "マジョリティ"
        end
        @village = Village.new(roomNum: params[:roomNum] , villageNum: villageNumOrd , name: @showVilListAry[0][:name] , email: @showVilListAry[0][:email] , position: position , theme: @theme)
        @village.save
      end

    elsif max <= 10 # 	７～１０人  マイノリティ*１、ストーカー*１、インフルエンサー*１、他マジョリティ
      @showVilListAry.each_with_index do |village , i|
        if i == gmnaituu[0]
          position = "マイノリティ"
        elsif i == gmnaituu[1] 
          position = "ストーカー"
        elsif i == gmnaituu[2] 
          position = "インフルエンサー"
        else
          position = "マジョリティ"
        end
        @village = Village.new(roomNum: params[:roomNum] , villageNum: villageNumOrd , name: @showVilListAry[0][:name] , email: @showVilListAry[0][:email] , position: position , theme: @theme)
        @village.save
      end

    else            # 	１１人以上  マイノリティ*１、ストーカー*２、インフルエンサー*１、他マジョリティ
      @showVilListAry.each_with_index do |village , i|
        if i == gmnaituu[0]
          position = "マイノリティ"
        elsif i == gmnaituu[1] 
          position = "ストーカー"
        elsif i == gmnaituu[2] 
          position = "ストーカー"
        elsif i == gmnaituu[3] 
          position = "インフルエンサー"
        else
          position = "マジョリティ"
        end
        @village = Village.new(roomNum: params[:roomNum] , villageNum: villageNumOrd , name: @showVilListAry[0][:name] , email: @showVilListAry[0][:email] , position: position , theme: @theme)
        @village.save
      end
    end

    # ChatChannel.broadcast_to('message', {"message"=>"show_village", "roomNum"=>params[:roomNum], "villageNum"=> villageNumOrd ,"action"=>"show_village"})

    # redirect_to action: 'show' , villageNum: villageNumOrd , roomNum: params[:roomNum]  # name: params[:name] , roomId: params[:roomId] , 
    redirect_to @village
  end





  def board
    logger.debug("Villages#boardに入りました")

  end
  

  def show
    # params villageNum: villageNumOrd , roomNum: params[:roomNum]
    logger.debug("Village#showに入りました")
    logger.debug(params)
    
    @village = Village.find(params[:id])
    @theme   = @village.theme

    @room = Room.where(email: current_user.email).where(roomNum: @village.roomNum)[0]
    
    # 自身のvillage情報に上書き
    @village = Village.where(villageNum: @village.villageNum).where(email: current_user.email)[0]
    
    logger.debug("役職： #{@village.position}")
  end

  def index
    logger.debug("Villages#indexに入りました")
    
    # お題　作成
    @theme = Theme.where( 'id >= ?', rand(Theme.first.id..Theme.last.id) ).first.content
    
  end

end
