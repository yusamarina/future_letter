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
      const body = `idToken=${idToken}`
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
  postFormElm.addEventListener('ajax:success', function () {
    alert("保存しました。");
    window.location = '/anniversaries';
  })
})
