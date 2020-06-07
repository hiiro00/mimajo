(function() {
  var reguType, updateRegu;

  reguType = function(memCnt) {
    if (memCnt <= 4) {
      return 0;
    } else if (memCnt <= 6) {
      return 1;
    } else if (memCnt <= 10) {
      return 2;
    } else {
      return 3;
    }
  };

  updateRegu = function(oldMemCnt, newMemCont) {
    var newReguType, oldReguType, text;
    text = ["		マイノリティー・・・１人<br>\n		マジョリティー　・・残り<br>\n", "		マイノリティー・・・１人<br>\n		インフルエンサー・・１人<br>\n		マジョリティー　・・残り<br>", "		マイノリティー・・・１人<br>\n		インフルエンサー・・１人<br>\n		ストーカー・・・・・１人<br>\n		マジョリティー　・・残り<br>", "		マイノリティー・・・１人<br>\n		インフルエンサー・・１人<br>\n		ストーカー・・・・・２人<br>\n		マジョリティー　・・残り<br>"];
    oldReguType = reguType(oldMemCnt);
    newReguType = reguType(newMemCont);
    if (oldReguType !== newReguType) {
      return document.getElementById('room_regu').innerHTML = text[newReguType];
    }
  };

  App.chat = App.cable.subscriptions.create("ChatChannel", {
    connected: function() {
      return console.log("接続開始");
    },
    disconnected: function() {
      return console.log("接続失敗");
    },
    received: function(data) {
      var a, d, datatag, e, i, j, k, len, len1, memlist, memlist_span, mesg, oldMemCnt, rslt_hit, span, strg, tspan;
      console.log('chat#received処理開始');
      console.log(data);
      mesg = data['message'];
      if (document.getElementById('disp_show_room') !== null) {
        console.log('部屋画面向け処理開始');
        console.log(data);
        datatag = document.getElementById('datatag');
        console.log("datatag.dataset.roomnum: " + "%s", datatag.dataset.roomnum);
        console.log(data['roomNum']);
        if (datatag.dataset.roomnum === data['roomNum']) {
          console.log('room_num.textContent 一致');
          if (mesg === "room_controlle_join") {
            console.log('room_controlle_join 一致');
            memlist = document.getElementById('show_room_mem');
            memlist_span = memlist.getElementsByTagName('span');
            rslt_hit = false;
            for (i = j = 0, len = memlist_span.length; j < len; i = ++j) {
              d = memlist_span[i];
              console.log(d);
              if (d.getAttribute('id') === data['email']) {
                rslt_hit = true;
                return;
              }
            }
            console.log('リストに一致判定　ture(あり)/false(なし): %s', rslt_hit);
            if (rslt_hit === false) {
              oldMemCnt = memlist_span.length;
              span = document.createElement('span');
              span.textContent = data['name'];
              span.setAttribute("class", "member inner");
              span.setAttribute("id", data['email']);
              e = document.getElementById('show_room_mem');
              e.appendChild(document.createTextNode('\n'));
              e.appendChild(span);
              if (datatag.dataset.position === "owner") {
                console.log('ownerの時のみ、メンバー　バン機能をつける');
                tspan = document.getElementById(data['email']);
                tspan.appendChild(document.createTextNode('\n'));
                a = document.createElement('a');
                a.setAttribute("data-confirm", "メンバーを外します。OK?");
                a.setAttribute("data-remote", "true");
                a.setAttribute("rel", "nofollow");
                a.setAttribute("data-method", "put");
                strg = "/rooms/room_out_member?email=" + data['email'] + "&roomNum=" + data['roomNum'];
                console.log(strg);
                a.setAttribute("href", strg);
                tspan.appendChild(a);
              }
              updateRegu(oldMemCnt, e.getElementsByTagName('span').length);
            }
          }
          if (mesg === "room_controlle_logout") {
            console.log('room_controlle_logout 一致');
            memlist = document.getElementById('show_room_mem');
            memlist_span = memlist.getElementsByTagName('span');
            for (i = k = 0, len1 = memlist_span.length; k < len1; i = ++k) {
              d = memlist_span[i];
              if (d.getAttribute('id') === data['email']) {
                oldMemCnt = memlist_span.length;
                memlist.removeChild(d);
                updateRegu(oldMemCnt, memlist.getElementsByTagName('span').length);
                return;
              }
            }
          }
          if (mesg === "show_village") {
            console.log("村　開始モーダル表示show_village文を通った");
            if (document.getElementById('datatag').dataset.position === "member") {
              $('#modal_start_vil').modal('show');
              $('#datatag').data('roomnum', data['roomNum']);
              $('#datatag').data('villagenum', data['villageNum']);
            }
          }
          if (mesg === "room_controlle_close") {
            console.log("room_controlle_close文を通った");
            if (datatag.dataset.position === "member") {
              $('#modal_close_room').modal('show');
            }
          }
          if (mesg === "err_createVlg_lackmember") {
            console.log("err_createVlg_lackmember文を通った");
            if ($('#showvil_datatag').data('position') === "owner") {
              $('#modal_err_createVlg_lackmember').modal('show');
            }
          }
        }
      }
      if ((document.getElementById('disp_show_village') !== null) || (document.getElementById('disp_show_board'))) {
        console.log('村（役職）画面向け処理開始');
        console.log(data);
        if (mesg === "notif_result") {
          console.log('ゲーム結果を全員に通知　処理開始');
          console.log('showvil_datatag_villageNumの出力 : %s', $('#datatag').data('villagenum'));
          console.log('data[villageNum] : %s', data['villageNum']);
          if ($('#datatag').data('villagenum').textContent === data['villageNum'].textContent) {
            console.log('村id一致');
            $('#modal_notif_result').find('.modal-body').html(data['resultMsg']);
            return $('#modal_notif_result').modal('show');
          }
        }
      }
    }
  });

}).call(this);
