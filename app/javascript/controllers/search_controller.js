import { Controller } from "stimulus"
import hotkeys from "hotkeys-js"

export default class extends Controller {
  static targets = ["input"]

  initialize() {
    this.searchHotKey = "/"
  }

  connect() {
    const element = this.inputTarget
    hotkeys(this.searchHotKey, (event, handler) => {
      event.preventDefault()
      element.focus()
    })
  }

  disconnect() {
    hotkeys.unbind(this.searchHotKey)
  }
}
