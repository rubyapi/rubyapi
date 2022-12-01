import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets: string[] = ["mobileMenuButton", "mobileMenu"]

  declare readonly mobileMenuButtonTarget: HTMLButtonElement
  declare readonly mobileMenuTarget: HTMLDivElement

  toggleMobileMenu (): void {
    this.mobileMenuTarget.classList.toggle("hidden")
    this.mobileMenuButtonTarget.classList.toggle("active")
  }
}
