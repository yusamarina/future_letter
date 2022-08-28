document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const LIFF_ID = process.env.LIFF_ID
  liff.init({
    liffId: LIFF_ID
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
    const liff_id = process.env.LIFF_ID
    const redirect_url = `https://liff.line.me/${liff_id}/open?token=${e.detail[0].token}`
    liff.shareTargetPicker(
      [
        message = {
          "type": "template",
          "altText": "メッセージが届いています。",
          "template": {
            "thumbnailImageUrl": "https://cdn.pixabay.com/photo/2016/10/16/21/30/newspaper-1746350_1280.jpg",
              "type": "buttons",
              "title": "FUTURE LETTER",
              "text": "お手紙を送りたいです！\n宛名を確認してください。",
              "actions": [
                  {
                    "type": "uri",
                    "label": "お手紙はこちら",
                    "uri": redirect_url
                  }
              ]
          }
        }
      ]
    ).then((res) => {
      if (res) {
        liff.closeWindow()
        fetch('/message');
      } else {
        alert("下書き保存しました。")
        window.location = '/letters';
      }
    })
  })
})
