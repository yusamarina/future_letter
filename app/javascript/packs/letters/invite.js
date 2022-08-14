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
          dataId = data.id
        })
        .then(() => {
          const postFormElm = document.querySelector('#ok')
          postFormElm.addEventListener('ajax:success', (e) => {
            const letterToken = e.detail[0].token
            const data = `idToken=${idToken}&dataId=${dataId}&letterToken=${letterToken}`
            const req = new Request('/send_letters', {
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
                'X-CSRF-Token': token
              },
              method: 'POST',
              body: data
            });

            fetch(req)
              .then(response => response.json())
              .then(data => {
                data_id = data.id
              })
              .then(() => {
                window.location = '/friend'
              })
              .catch((err) => {
                console.log(err.code, err.message);
              });
          })
        })
    })
})
