import { Controller } from "stimulus"
import hotkeys from "hotkeys-js"

export default class extends Controller {
  static targets = ["versionList", "versionOverlay"]

  connect() {
    hotkeys("escape", () => { this.hideOverlay() })
  }

  disconnect() {
    hotkeys.unbind("escpae")
  }

  hideOverlay() {
    this.versionListTarget.classList.add("invisible")
    this.versionOverlayTarget.classList.add("invisible") 
  }

  in() {
    this.versionListTarget.classList.remove("invisible")
    this.versionOverlayTarget.classList.remove("invisible")
  }

  out() {
    this.hideOverlay()
  }
}