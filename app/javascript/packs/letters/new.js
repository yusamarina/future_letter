document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  liff.init({
    liffId: gon.liff_id
  })
    .then(() => {
      if (!liff.isLoggedIn()) {
        liff.login();
      }
    })

    .then(() => {
      const idToken = liff.getIDToken()
      const body =`idToken=${idToken}`
      const request = new Request('/users', {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
          'X-CSRF-Token': token
        },
        method: 'POST',
        body: body
      });

    fetch(request)
    .then(response => response.json())
      .then(data => {
        data_id = data.id
      })
  })

  const postFormElm = document.querySelector('#form')
  postFormElm.addEventListener('ajax:success', (e) => {

    // gon.liff_id部分の埋め込み方法を考える。
    const redirect_url = `https://liff.line.me/gon.liff_id/login?token=${e.detail[0].token}`
    liff.shareTargetPicker([
      message = {
        "type": "template",
        "altText": "お手紙が届いています。",
        "template": {
            "thumbnailImageUrl": "https://s4.aconvert.com/convert/p3r68-cdx67/a6pzu-mzopp.jpg",
            "type": "buttons",
            "title": "お手紙",
            "text": "お手紙を書きました！",
            "actions": [
                {
                  "type": "uri",
                  "label": "お手紙はこちら",
                  "uri": redirect_url
                }
            ]
        }
      }
    ]).then((res) => {
      if (res) {
        liff.closeWindow();
      } else {
        console.log('TargetPicker was closed!')
        liff.closeWindow();
      }
    })
    .then(() => {
      fetch('/message')
    })
    .catch(function (res) {
      alert("送信に失敗しました…もう一度送ってください。")
    });
  })
})
