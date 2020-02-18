const osDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches
const supportsLocalStorage = 'localStorage' in window
const darkModeCheckbox = document.getElementById('darkmode')

if (supportsLocalStorage) {
  darkModeCheckbox.addEventListener('change', rememberDarkmode)
  const darkMode = localStorage.getItem('rubyapi-darkMode')

  if (darkMode !== null) {
    darkModeCheckbox.checked = darkMode === '1'
  } else if (osDarkMode && darkMode === null) {
    darkModeCheckbox.checked = true
  }

  function rememberDarkmode () {
    if (darkModeCheckbox.checked) {
      localStorage.setItem('rubyapi-darkMode', '1')
    } else {
      localStorage.setItem('rubyapi-darkMode', '0')
    }
  }
}
