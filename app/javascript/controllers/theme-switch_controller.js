import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["switch"]

  connect() {
    const osDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches
    const supportsLocalStorage = 'localStorage' in window

    if (supportsLocalStorage) {
      const darkMode = localStorage.getItem('rubyapi-darkMode')

      if (darkMode !== null && darkMode === '1') {
        this.setDarkMode(this.switchTarget)
      } else if (osDarkMode && darkMode === null) {
        this.setDarkMode(this.switchTarget)
      }
    }
  }

  setLightMode(target) {
    target.classList.replace("fa-moon", "fa-sun")
    document.documentElement.classList.remove("mode-dark")
    localStorage.setItem('rubyapi-darkMode', '0')
  }

  setDarkMode(target) {
    target.classList.replace("fa-sun", "fa-moon")
    document.documentElement.classList.add("mode-dark")
    localStorage.setItem('rubyapi-darkMode', '1')
  }

  toggle() {
    if (this.switchTarget.classList.contains('fa-sun')) {
      this.setDarkMode(this.switchTarget)
    } else {
      this.setLightMode(this.switchTarget)
    }
  }
}
