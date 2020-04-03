import { Controller } from "stimulus"

function setDarkMode(value) {
  if (value == null) value = document.body.dataset.theme == 'light'
  document.body.dataset.theme = value ? 'dark' : 'light'
}

export default class extends Controller {
  connect() {
    const osDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches
    const supportsLocalStorage = 'localStorage' in window

    if (supportsLocalStorage) {
      const darkMode = localStorage.getItem('rubyapi-darkMode')
      console.debug(darkMode)

      if (
        (darkMode !== null && darkMode == 'true') ||
          (osDarkMode && darkMode == null)
      ) {
        setDarkMode(true)
      }
    }
  }

  toggle() {
    setDarkMode()
    localStorage.setItem(
      'rubyapi-darkMode', document.body.dataset.theme == 'dark'
    )
  }
}
