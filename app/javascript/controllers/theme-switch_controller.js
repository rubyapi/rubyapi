import { Controller } from "stimulus"

function setLightMode(target) {
  target.classList.replace("dark-switch", "light-switch")
  document.body.dataset.theme = 'light'
}

function setDarkMode(target) {
  target.classList.replace("light-switch", "dark-switch")
  document.body.dataset.theme = 'dark'
}

export default class extends Controller {
  static targets = ["switch"]

  connect() {
    const osDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches
    const supportsLocalStorage = 'localStorage' in window

    if (supportsLocalStorage) {
      const darkMode = localStorage.getItem('rubyapi-darkMode')

      if (darkMode !== null && darkMode === '1') {
        setDarkMode(this.switchTarget)
      } else if (osDarkMode && darkMode === null) {
        setDarkMode(this.switchTarget)
      }
    }
  }

  toggle() {
    if (this.switchTarget.classList.contains('light-switch')) {
      setDarkMode(this.switchTarget)
      localStorage.setItem('rubyapi-darkMode', '1')
    } else {
      setLightMode(this.switchTarget)
      localStorage.setItem('rubyapi-darkMode', '0')
    }
  }
}
