document.addEventListener('DOMContentLoaded', () => {
  const LIFF_ID = process.env.LIFF_ID
  liff.init({
    liffId: LIFF_ID
  })
})
