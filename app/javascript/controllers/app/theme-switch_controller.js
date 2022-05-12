import { Controller } from "@hotwired/stimulus"

const sunIcon = `
<svg xmlns="http://www.w3.org/2000/svg" class="inline h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
  <path fill-rule="evenodd" d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z" clip-rule="evenodd" />
</svg>`

const moonIcon = `
<svg xmlns="http://www.w3.org/2000/svg" class="inline h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
  <path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z" />
</svg>`

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
  if (target) {
    target.setAttribute("data-theme", "dark")
    target.innerHTML = moonIcon
  }

  document.documentElement.classList.add("dark")
  setMetaThemeColor('#374151')
  localStorage.setItem('rubyapi-darkMode', '1')
}

const setLightMode = (target) => {
  if (target) {
    target.setAttribute("data-theme", "light")
    target.innerHTML = sunIcon
  }

  document.documentElement.classList.remove("dark")
  setMetaThemeColor('#e1175a')
  localStorage.setItem('rubyapi-darkMode', '0')
}

const setMetaThemeColor = (color) => {
  const meta = document.querySelector('meta[name="theme-color"]')
  if (meta) {
    meta.content = color
  }
}

export default class extends Controller {
  static targets = ["switch"]

  connect() {
    setTheme(this.switchTarget)
  }

  toggle() {
    if (this.switchTarget.getAttribute("data-theme") == "light") {
      setDarkMode(this.switchTarget)
    } else {
      setLightMode(this.switchTarget)
    }
  }
}
