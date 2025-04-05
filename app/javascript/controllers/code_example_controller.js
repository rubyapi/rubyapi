import { Controller } from "@hotwired/stimulus"
import copy from "clipboard-copy"

export default class extends Controller {
  static targets = ["block", "copy", "run"]

  connect() {
    const codeBar = document.createElement("div")
    codeBar.classList.add("w-full", "px-3", "py-2", "bg-code-header", "dark:bg-gray-700", "items-center", "flex", "justify-between", "font-mono", "rounded-t")
    codeBar.innerHTML = "<span class=\"text-gray-300 text-sm\">Example</span><div><button title=\"Copy to clipboard\" class=\"pl-2\" data-action=\"click->code-example#copy\" aria-label=\"Copy to clipboard\"><span data-code-example-target=\"copy\" class=\"text-gray-300 fill-current hover:text-gray-500\"><svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-5 w-5\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path d=\"M8 3a1 1 0 011-1h2a1 1 0 110 2H9a1 1 0 01-1-1z\" /><path d=\"M6 3a2 2 0 00-2 2v11a2 2 0 002 2h8a2 2 0 002-2V5a2 2 0 00-2-2 3 3 0 01-3 3H9a3 3 0 01-3-3z\" /></svg></span></button></div>"

    this.blockTarget.append(codeBar)
  }

  copy() {
    const snippet = this.element.nextElementSibling
    copy(snippet?.textContent ?? "")
      .then(() => {
        this.copyTarget.innerHTML = "<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-5 w-5\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path fill-rule=\"evenodd\" d=\"M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z\" clip-rule=\"evenodd\" /></svg>"
        setTimeout(() => {
          this.copyTarget.innerHTML = "<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-5 w-5\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path d=\"M8 2a1 1 0 000 2h2a1 1 0 100-2H8z\" /><path d=\"M3 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v6h-4.586l1.293-1.293a1 1 0 00-1.414-1.414l-3 3a1 1 0 000 1.414l3 3a1 1 0 001.414-1.414L10.414 13H15v3a2 2 0 01-2 2H5a2 2 0 01-2-2V5zM15 11h2a1 1 0 110 2h-2v-2z\" /></svg>"
        }, 3000)
      })
      .catch(() => { })
  }
}
