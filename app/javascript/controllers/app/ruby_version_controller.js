import { Controller } from "stimulus"
import hotkeys from "hotkeys-js"

export default class extends Controller {
  static targets = ["versionList", "versionOverlay"]

  connect() {
    hotkeys("escape", () => { this.hideList() })
    this.listActive = false
  }

  disconnect() {
    hotkeys.unbind("escape")
  }

  hideList() {
    this.versionListTarget.classList.add("invisible")
    this.versionOverlayTarget.classList.add("invisible") 
    this.listActive = false
  }

  showList() {
    ["dropdown", "dropdown-overlay"].forEach(c => {
      Array.from(document.getElementsByClassName(c)).forEach(e => {
        e.classList.add("invisible")
      })
    })

    this.versionListTarget.classList.remove("invisible")
    this.versionOverlayTarget.classList.remove("invisible")
    this.listActive = true
  }

  out() {
    this.hideList()
  }

  toggle() {
    if(this.listActive) {
      this.hideList()
    } else {
      this.showList()
    }
  }
}