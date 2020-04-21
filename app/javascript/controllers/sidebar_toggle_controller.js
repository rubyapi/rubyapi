import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["versionList", "versionOverlay"]

  toggle() {
    document.body.classList.toggle('sidebar-opened')
  }

  close() {
    document.body.classList.remove('sidebar-opened')
  }
}
