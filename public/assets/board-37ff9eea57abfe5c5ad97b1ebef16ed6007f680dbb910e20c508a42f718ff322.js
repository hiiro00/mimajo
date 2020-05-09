'use strict';

{

  let x = 1;
  let textLength = 0;
  let bairitu = 0;

  const info = document.getElementById('textarea_board');

  info.addEventListener('input',()=>{
    textLength = info.textLength;

    if ( textLength > 3){
      // console.log('6以上')
      bairitu = 3/(textLength+0.8);
      info.style.fontSize = x*bairitu + 'em';
    }else{
      info.style.fontSize = x + 'em';
    }
    // console.log()

    // x = x*0.8;
    // info.style.fontSize = x + 'em';


  });
}
;
