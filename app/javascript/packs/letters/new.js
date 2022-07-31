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
    // liff_id部分の埋め込み方法を考える。
    const redirect_url = `https://liff.line.me/liff_id/open?token=${e.detail[0].token}`
    liff.shareTargetPicker([
      message = {
        "type": "template",
        "altText": "メッセージが届いています。",
        "template": {
          "thumbnailImageUrl": "https://photo-cdn2.icons8.com/brt9x13Zw6j73rN4WiO7eJAicpfu_uWitaTeSYif2TM/rs:fit:1606:1072/czM6Ly9pY29uczgu/bW9vc2UtcHJvZC5h/c3NldHMvYXNzZXRz/L3NhdGEvb3JpZ2lu/YWwvMTYxLzIzNDE3/N2IzLWRmZWEtNDI2/Yi1hZGZkLWE0NjZl/YzgzMTRkZC5qcGc.jpg",
            "type": "buttons",
            "title": "お手紙",
            "text": "宛先を確認してください！",
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
