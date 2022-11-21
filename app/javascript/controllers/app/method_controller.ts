import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets: string[] = ["srcBody", "showSrcBodyButton"]

  declare readonly srcBodyTarget: HTMLDivElement
  declare readonly showSrcBodyButtonTarget: HTMLButtonElement

  toggleShowSource (event: Event): void {
    event.preventDefault()

    this.showSrcBodyButtonTarget.classList.toggle("bg-blue-600")
    this.showSrcBodyButtonTarget.classList.toggle("text-white")
    this.showSrcBodyButtonTarget.classList.toggle("hover:bg-blue-700")
    this.showSrcBodyButtonTarget.classList.toggle("hover:text-white-300")
    this.showSrcBodyButtonTarget.classList.toggle("dark:bg-gray-900")
    this.srcBodyTarget.classList.toggle("hidden")
  }
}
