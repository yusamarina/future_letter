document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  const ADMIN_LIFF_ID = process.env.ADMIN_LIFF_ID
  liff.init({
    liffId: ADMIN_LIFF_ID
  })
    .then(() => {
      if (!liff.isLoggedIn()) {
        liff.login()
      }
    })
    .then(() => {
      const idToken = liff.getIDToken()
      const body = `idToken=${idToken}`
      const request = new Request('/admin/login', {
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
        data_id = data
      })
    })
})
