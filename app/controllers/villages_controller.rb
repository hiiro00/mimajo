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
    @showRoomNum,@showOwnName,@showMemberTxt,@showVilListAry,@showMemListAry,@showOwnData = Room.getRoomShowText(params[:roomNum].to_i)

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
    logger.debug("■村　人数： #{max}")

    
    gmnaituu = (0..(max-1)).to_a.sort_by{rand}
    logger.debug("■抽選用　gmnaituu： #{gmnaituu}")

    # 	４人     マイノリティ*１、他マジョリティ
    # 	５～６人   マイノリティ*１、ストーカー*１、他マジョリティ
    # 	７～１０人  マイノリティ*１、ストーカー*１、インフルエンサー*１、他マジョリティ
    # 	１１人以上  マイノリティ*１、ストーカー*２、インフルエンサー*１、他マジョリティ

    # 人数別配役　配置
    if max <= 1     # 	１人     マイノリティ　特殊な許容
      logger.debug("■村create 人数別配役　配置 一人用")
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
      logger.debug("■村create 人数別配役　配置 ４人以下用")
      @showVilListAry.each_with_index do |village , i|
        # binding.pry
        if i == gmnaituu[0]
          position = "マイノリティ"
        else
          position = "マジョリティ"
        end
        @village = Village.new(roomNum: params[:roomNum] , villageNum: villageNumOrd , name: village[:name] , email: village[:email] , position: position , theme: @theme)
        @village.save
      end

    elsif max <= 6  # 	５～６人   マイノリティ*１、インフルエンサー*１、他マジョリティ
      logger.debug("■村create 人数別配役　配置 ６人以下用")
      @showVilListAry.each_with_index do |village , i|
        if i == gmnaituu[0]
          position = "マイノリティ"
        elsif i == gmnaituu[1] 
          position = "インフルエンサー"
        else
          position = "マジョリティ"
        end
        @village = Village.new(roomNum: params[:roomNum] , villageNum: villageNumOrd , name: village[:name] , email: village[:email] , position: position , theme: @theme)
        @village.save
      end

    elsif max <= 10 # 	７～１０人  マイノリティ*１、ストーカー*１、インフルエンサー*１、他マジョリティ
      logger.debug("■村create 人数別配役　配置 １０人以下用")
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
        @village = Village.new(roomNum: params[:roomNum] , villageNum: villageNumOrd , name: village[:name] , email: village[:email] , position: position , theme: @theme)
        @village.save
      end

    else            # 	１１人以上  マイノリティ*１、ストーカー*２、インフルエンサー*１、他マジョリティ
      logger.debug("■村create 人数別配役　配置 １１人以上用")
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
        @village = Village.new(roomNum: params[:roomNum] , villageNum: villageNumOrd , name: village[:name] , email: village[:email] , position: position , theme: @theme)
        @village.save
      end
    end

    ChatChannel.broadcast_to('message', {"message"=>"show_village", "roomNum"=>params[:roomNum], "villageNum"=> villageNumOrd ,"action"=>"show_village"})

    list = Village.where(villageNum: villageNumOrd)
    list.each do |member|
      logger.debug("■村　配役： #{member.name}  #{member.position}") 
    end

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

  def modal_trigger_show
    logger.debug("Village#modal_trigger_showに入りました")
    logger.debug(params)

    # redirect_to action: 'show' , villageNum: params[:villageNum].to_i , roomNum: params[:roomNum].to_i
    pram1 = '?villageNum=' + params[:villageNum] + '&roomNum=' + params[:roomNum] + '\''
    # pram2 = "window.location = '/villages/show" +  pram
    pram2 = Village.where(villageNum: params[:villageNum])[0].id.to_s +  pram1
    pram3 = "window.location = '/villages/" + pram2
    
    logger.debug("pram1: #{pram1}")
    logger.debug("pram2: #{pram2}")
    logger.debug("pram3: #{pram3}")

    render :js => pram3
    
  end

  # 村開始時に、部屋画面にいなかったメンバーへの再送通知（村開始）
  def resend_show_village
    logger.debug("Village#resend_show_villageに入りました")
    logger.debug(params)
  
    ChatChannel.broadcast_to('message', {"message"=>"show_village", "roomNum"=>params[:roomNum], "villageNum"=> params[:villageNum] ,"action"=>"show_village"})

  end
  
  # ゲーム結果を全員に通知する
  def notif_result_village
    logger.debug("Village#notif_result_villageに入りました")
    logger.debug(params)

    # マイノリティは一人のみ
    @village = Village.where(villageNum: params[:villageNum].to_i).where(position: "マイノリティ").first
    msg = "<h1>マイノリティ：#{@village.name}<br>"
    
    # ストーカーは複数人の可能性あり
    list = Village.where(villageNum: params[:villageNum].to_i).where(position: "ストーカー")
    list.each do |member|
      msg = msg + "<h1>ストーカー：#{member.name}<br>"
    end
    
    # インフルエンサーも複数対応
    list = Village.where(villageNum: params[:villageNum].to_i).where(position: "インフルエンサー")
    list.each do |member|
      msg = msg + "<h1>インフルエンサー：#{member.name}<br>"
    end

    ChatChannel.broadcast_to('message', {"message"=>"notif_result", "roomNum"=>params[:roomNum], "villageNum"=> params[:villageNum],"resultMsg"=>msg})

  end
  
  

end
