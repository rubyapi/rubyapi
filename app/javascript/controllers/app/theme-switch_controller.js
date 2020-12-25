import { Controller } from "stimulus"

export const setTheme = (switchTarget) => {
  const osDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches
  const supportsLocalStorage = 'localStorage' in window

  if (supportsLocalStorage) {
    const darkMode = localStorage.getItem('rubyapi-darkMode')

    if (darkMode !== null && darkMode === '1') {
      setDarkMode(switchTarget)
    } else if (osDarkMode && darkMode === null) {
      setDarkMode(switchTarget)
    }
  }
}

const setDarkMode = (target) => {
  if (target) target.classList.replace("fa-sun", "fa-moon")
  document.documentElement.classList.add("mode-dark")
  localStorage.setItem('rubyapi-darkMode', '1')
}

const setLightMode = (target) => {
  if (target) target.classList.replace("fa-moon", "fa-sun")
  document.documentElement.classList.remove("mode-dark")
  localStorage.setItem('rubyapi-darkMode', '0')
}
export default class extends Controller {
  static targets = ["switch"]

  connect() {
    setTheme(this.switchTarget)
  }

  toggle() {
    if (this.switchTarget.classList.contains('fa-sun')) {
      setDarkMode(this.switchTarget)
    } else {
      setLightMode(this.switchTarget)
    }
  }
}
