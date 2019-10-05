import { Controller } from "stimulus"
import hotkeys from "hotkeys-js"

export default class extends Controller {
  static targets = ["linksList", "linksOverlay"]

  connect() {
    hotkeys("escape", () => { this.hideOverlay() })
    this.listActive = false
  }

  disconnect() {
    hotkeys.unbind("escape")
  }

  hideList() {
    this.linksListTarget.classList.add("invisible")
    this.linksOverlayTarget.classList.add("invisible") 
    this.listActive = false
  }

  showList() {
    this.linksListTarget.classList.remove("invisible")
    this.linksOverlayTarget.classList.remove("invisible")
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