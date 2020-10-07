import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["switch"]

  connect() {
    const osDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches

    // Dark theme was previously stored using localStorage.
    // Migrate to a cookie if the old localStorage key is present.
    const supportsLocalStorage = 'localStorage' in window
    if (supportsLocalStorage) {
      const localStorageDarkMode = localStorage.getItem('rubyapi-darkMode')
      if (localStorageDarkMode !== null) {
        this.savePreference(localStorageDarkMode)
        localStorage.removeItem('rubyapi-darkMode')
      }
    }

    const cookies = document.cookie.split('; ')
    const darkModeCookie = cookies.find(cookie => cookie.startsWith('rubyapi-darkMode='))
    const darkMode = darkModeCookie !== undefined
      ? darkModeCookie.split("=")[1]
      : null

    if (darkMode !== null && darkMode === '1') {
      this.setDarkMode(this.switchTarget)
    } else if (osDarkMode && darkMode === null) {
      this.setDarkMode(this.switchTarget)
    } else {
      this.setLightMode(this.switchTarget)
    }
  }

  setLightMode(target) {
    target.classList.replace("fa-moon", "fa-sun")
    document.documentElement.classList.remove("mode-dark")
    this.savePreference(0)
  }

  setDarkMode(target) {
    target.classList.replace("fa-sun", "fa-moon")
    document.documentElement.classList.add("mode-dark")
    this.savePreference(1)
  }

  savePreference(value) {
    document.cookie = `rubyapi-darkMode=${value}; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/`
  }

  toggle() {
    if (this.switchTarget.classList.contains('fa-sun')) {
      this.setDarkMode(this.switchTarget)
    } else {
      this.setLightMode(this.switchTarget)
    }
  }
}
