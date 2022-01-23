import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenuButton", "mobileMenu"]

  toggleMobileMenu() {
    this.mobileMenuTarget.classList.toggle("hidden")
    this.mobileMenuButtonTarget.classList.toggle("active")
  }
}