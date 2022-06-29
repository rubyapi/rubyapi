import { Controller } from "@hotwired/stimulus"

const sunIcon = `
<svg xmlns="http://www.w3.org/2000/svg" class="inline h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
  <path fill-rule="evenodd" d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z" clip-rule="evenodd" />
</svg>`

const moonIcon = `
<svg xmlns="http://www.w3.org/2000/svg" class="inline h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
  <path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z" />
</svg>`

const systemDefaultIcon = `
<svg xmlns="http://www.w3.org/2000/svg" class="inline h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
  <path d="M5 4a1 1 0 00-2 0v7.268a2 2 0 000 3.464V16a1 1 0 102 0v-1.268a2 2 0 000-3.464V4zM11 4a1 1 0 10-2 0v1.268a2 2 0 000 3.464V16a1 1 0 102 0V8.732a2 2 0 000-3.464V4zM16 3a1 1 0 011 1v7.268a2 2 0 010 3.464V16a1 1 0 11-2 0v-1.268a2 2 0 010-3.464V4a1 1 0 011-1z" />
</svg>`

const supportsAuto = window.matchMedia('(prefers-color-scheme)').matches !== 'not all'
const supportsLocalStorage = 'localStorage' in window

const modes = [
  supportsAuto ? { name: 'auto', icon: systemDefaultIcon } : null,
  { name: 'light', icon: sunIcon },
  { name: 'dark', icon: moonIcon },
].filter(Boolean)

const modeNames = modes.map((m) => m.name)
const defaultMode = supportsAuto ? 'auto' : 'light'

const isDarkMode = (theme) => {
  return theme === 'dark' || (theme === 'auto' && window.matchMedia('(prefers-color-scheme: dark)').matches)
}

export const setTheme = (switchTarget) => {
  if (supportsLocalStorage) {
    const theme = localStorage.getItem('rubyapi-theme') || defaultMode

    setMode(theme, switchTarget)
  }
}

const setMode = (theme, target) => {
  if (target) {
    target.setAttribute("data-theme", theme)
    target.innerHTML = modes.find((mode) => mode.name === theme).icon
  }

  if (isDarkMode(theme)) {
    document.documentElement.classList.add("dark")
    setMetaThemeColor('#374151')
  } else {
    document.documentElement.classList.remove("dark")
    setMetaThemeColor('#e1175a')
  }

  localStorage.setItem('rubyapi-theme', theme)
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

    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
      setTheme(this.switchTarget)
    })
  }

  toggle() {
    const currentTheme = this.switchTarget.getAttribute("data-theme") || defaultMode
    const newTheme = modes[(modeNames.indexOf(currentTheme) + 1) % modeNames.length].name

    setMode(newTheme, this.switchTarget)
  }
}
