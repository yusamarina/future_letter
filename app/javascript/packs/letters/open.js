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
      const idToken = liff.getIDToken();
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
        .then(() => {
          const params = new URLSearchParams(window.location.search);
          const letter_token = params.get('token')
          const redirect_url = `/letters/${letter_token}`
          window.location = redirect_url
        })
    })
})
