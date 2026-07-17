import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["srcBody", "showSrcBodyButton"]

  toggleShowSource(event) {
    event.preventDefault()
    this.#toggleAttrValue(this.showSrcBodyButtonTarget, "aria-pressed", "true", "false")
    this.srcBodyTarget.toggleAttribute("data-open")
  }

  // Toggles an attribute between two values.
  //
  //   this.#toggleAttrValue(el, "data-state", "active", "inactive")
  //
  #toggleAttrValue(element, attr, toggleValue, initValue) {
    const shouldToggle = element.getAttribute(attr) !== toggleValue
    if (shouldToggle) {
      element.setAttribute(attr, toggleValue)
    } else {
      element.setAttribute(attr, initValue)
    }
  }
}
