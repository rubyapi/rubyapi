import Dropdown from "@stimulus-components/dropdown"

export default class extends Dropdown {
  static targets = ["menu", "trigger"]

  connect() {
    super.connect()
    this.syncAriaExpanded()
  }

  toggle(event) {
    super.toggle(event)
    requestAnimationFrame(() => this.syncAriaExpanded())
  }

  hide(event) {
    super.hide(event)
    requestAnimationFrame(() => this.syncAriaExpanded())
  }

  syncAriaExpanded() {
    if (!this.hasTriggerTarget || !this.hasMenuTarget) return
    const expanded = !this.menuTarget.classList.contains("hidden")
    this.triggerTarget.setAttribute("aria-expanded", String(expanded))
  }
}
