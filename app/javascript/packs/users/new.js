document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  liff.init({
    liffId: gon.liff_id
  })
    .then(() => {
      if (!liff.isLoggedIn()) {
        liff.login()
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
      .then(() => {
        window.location = '/letters'
      })
    })
})
