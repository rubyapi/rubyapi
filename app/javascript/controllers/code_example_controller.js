import { Controller } from "stimulus"
import copy from 'clipboard-copy'

export default class extends Controller {
  static targets = ["block", "copy"]

  connect() {
    const codeBar = document.createElement("div")
    codeBar.classList.add("w-full", "px-3", "py-2", "bg-code-header", "items-center", "flex", "justify-between", "font-mono", "rounded-t")
    codeBar.innerHTML = "<h4 class=\"text-gray-300 text-sm\">Example</h4><button tilte=\"Copy to clipboard\" data-action=\"click->code-example#copy\" aria-label=\"Copy to clipboard\"><span data-target=\"code-example.copy\" class=\"text-gray-300 fill-current hover:text-gray-500\"><i class=\"far fa-copy\"></i></span></button>"

    this.blockTarget.append(codeBar)
  }

  copy() {
    const snippet = this.element.nextElementSibling
    copy(snippet.textContent)
      .then(() => {
        this.copyTarget.innerHTML = "<i class=\"fas fa-check\"></i>"
        setTimeout(() => {
          this.copyTarget.innerHTML = "<i class=\"far fa-copy\"></i>"
        }, 3000);
      })
  }
}