reguType = (memCnt) ->
  if memCnt <= 4
    0
  else if memCnt <= 6
    1
  else if memCnt <= 10
    2
  else
    3

updateRegu = (oldMemCnt , newMemCont) ->
  text = [
   "		マイノリティー・・・１人<br>\n		マジョリティー　・・残り<br>\n"
   "		マイノリティー・・・１人<br>\n		ストーカー・・・・・１人<br>\n		マジョリティー　・・残り<br>"
   "		マイノリティー・・・１人<br>\n		インフルエンサー・・１人<br>\n		ストーカー・・・・・１人<br>\n		マジョリティー　・・残り<br>"
   "		マイノリティー・・・１人<br>\n		インフルエンサー・・１人<br>\n		ストーカー・・・・・２人<br>\n		マジョリティー　・・残り<br>"]
  oldReguType = reguType(oldMemCnt)
  newReguType = reguType(newMemCont)
  
  if oldReguType != newReguType
    document.getElementById('room_regu').innerHTML = text[newReguType]


App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    console.log("接続開始")
    # Called when the subscription is ready for use on the server

  disconnected: ->
    console.log("接続失敗")
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log('chat#received処理開始')
    console.log(data)
    mesg = data['message']
    
    #　部屋画面
    if document.getElementById('disp_show_room') != null
      
      console.log('部屋画面向け処理開始')
      console.log(data)
      
      # # 動作確認用　testコード start
      # if(mesg == "room_controlle_join")
      #   console.log('testコード room_controlle_join 一致')

      #   span = document.createElement('span')
      #   span.textContent = data['name']
      #   span.setAttribute("class", "member inner")
        
      #   # 改行エレメントを前に作る必要がある
      #   e = document.getElementById('show_room_mem')
      #   e.appendChild( document.createTextNode('\n'))
        
      #   document.getElementById('show_room_mem').appendChild(span)
      #   # 動作確認用　testコード end

      # 通知のroomNumと自分のroomNumが一致している場合
      datatag = document.getElementById('datatag')
      
      console.log("datatag.dataset.roomnum: " + "%s", datatag.dataset.roomnum)
      console.log(data['roomNum'])
      
      if datatag.dataset.roomnum == data['roomNum']
        console.log('room_num.textContent 一致')
        
        # 部屋に参加　通知の場合
        if(mesg == "room_controlle_join")
          console.log('room_controlle_join 一致')

          # console.log('data_email: %s', data['email'])
          memlist = document.getElementById('show_room_mem')
          memlist_span = memlist.getElementsByTagName('span')

          # リストに一致するものが一個もないか全件検索にて確認
          rslt_hit = false
          for d,i in memlist_span
            console.log(d)
            if d.getAttribute('id') == data['email']
              rslt_hit = true
              return
          
          console.log('リストに一致判定　ture(あり)/false(なし): %s', rslt_hit);
          # リストに一致するものがない為、追加
          if rslt_hit == false
            # 追加前に、メンバー数保持
            oldMemCnt = memlist_span.length

            span = document.createElement('span')
            span.textContent = data['name']
            span.setAttribute("class", "member inner")
            span.setAttribute("id", data['email'])
            
            # 改行エレメントを前に作る必要がある インデントくずれ回避の為
            e = document.getElementById('show_room_mem')
            e.appendChild( document.createTextNode('\n'))
            
            e.appendChild(span)
            
            # 必要に応じて、レギュ内容更新
            updateRegu(oldMemCnt,e.getElementsByTagName('span').length)
            

        
        # 部屋から抜ける　通知の場合
        if(mesg == "room_controlle_logout")
          console.log('room_controlle_logout 一致')
          memlist = document.getElementById('show_room_mem')
          memlist_span = memlist.getElementsByTagName('span')
          
          for d,i in memlist_span
            if d.getAttribute('id') == data['email']
              
              # 一致した場合のみ、削除処理
              
              # 削除前に、メンバー数保持
              oldMemCnt = memlist_span.length
              
              memlist.removeChild d
              
              # 必要に応じて、レギュ内容更新
              updateRegu(oldMemCnt,memlist.getElementsByTagName('span').length)
              

              return

        # 村　開始モーダル表示
        if(mesg == "show_village")
          console.log("村　開始モーダル表示show_village文を通った")
          
          # 自分がmemberの時のみ表示
          if document.getElementById('datatag').dataset.position == "member"
            $('#modal_start_vil').modal('show')
            $('#datatag').data('roomnum',data['roomNum']);
            $('#datatag').data('villagenum',data['villageNum']);


        # 部屋　クローズ
        if(mesg == "room_controlle_close")
          console.log("room_controlle_close文を通った")
          
          # 自分がmemberの時のみ表示
          if datatag.dataset.position == "member"
            $('#modal_close_room').modal('show')
        
        # 村　開始失敗モーダル表示　人数不足
        # 本機能　未実装
        if(mesg == "err_createVlg_lackmember")
          console.log("err_createVlg_lackmember文を通った")
          
          # owner
          if $('#showvil_datatag').data('position') == "owner"
            $('#modal_err_createVlg_lackmember').modal('show')
        

    #　村（役職）画面
    if document.getElementById('disp_show_village') != null
      
      console.log('村（役職）画面向け処理開始')
      console.log(data)

      # ゲーム結果を全員に通知の場合
      if(mesg == "notif_result")
        
        console.log('ゲーム結果を全員に通知　処理開始')
        
        console.log('showvil_datatag_villageNumの出力 : %s', $('#datatag').data('villagenum'))
        console.log('data[villageNum] : %s',data['villageNum'])
        
        # 該当の村idの場合
        if $('#datatag').data('villagenum').textContent == data['villageNum'].textContent
          console.log('村id一致')
          $('#modal_notif_result').find('.modal-body').html(data['resultMsg']);
          # $('#modal_notif_result').find('.modal-body').html("<h1> 内通者：ローシ  お題：寝袋 </h1>");
          $('#modal_notif_result').modal('show')
          