import { Controller } from "stimulus"
import copy from 'clipboard-copy'

export default class extends Controller {
  static targets = ["block", "copy", "run"]

  connect() {
    const codeBar = document.createElement("div")
    codeBar.classList.add("w-full", "px-3", "py-2", "bg-code-header", "items-center", "flex", "justify-between", "font-mono", "rounded-t")
    codeBar.innerHTML = "<h4 class=\"text-gray-300 text-sm\">Example</h4><div><button class=\"px-2\" data-action=\"click->code-example#run\"><span class=\"text-gray-300 fill-current hover:text-gray-500\" data-target=\"code-example.run\"><i class=\"fas fa-play\"></i></span></button><button tilte=\"Copy to clipboard\" class=\"pl-2\" data-action=\"click->code-example#copy\" aria-label=\"Copy to clipboard\"><span data-target=\"code-example.copy\" class=\"text-gray-300 fill-current hover:text-gray-500\"><i class=\"far fa-copy\"></i></span></button></div>"

    this.blockTarget.append(codeBar)
  }

  run() {
    const snippet = this.element.nextElementSibling
    const csrfToken = document.head.querySelector("[name~=csrf-token]").getAttribute("content")
    const version = this.data.get("version")
    this.runTarget.innerHTML = '<i class=\"fas fa-sync fa-spin\"></i>'

    fetch("/run", {
      method: 'POST',
      body: JSON.stringify({
        snippet: snippet.textContent,
        version: version
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': csrfToken,
      },
      cache: 'no-cache',
      credentials: "same-origin"
    })
      .then((response) => response.json())
      .then((data) => {
        const resultDiv = document.createElement("pre")
        const output = `<span class="absolute top-0 right-0 m-2 px-2 py-1 text-experiment-notice bg-experiment-notice-background rounded text-sm"><i class="fas fa-info-circle"></i> Experimental Feature</span>`
        resultDiv.classList.add("w-full", "my-2", "p-3", "rounded", "text-executed-result", "bg-executed-result-background", "font-mono", "relative")

        resultDiv.innerHTML = output.concat(data.output)
        snippet.insertAdjacentElement('afterend', resultDiv)

        this.runTarget.innerHTML = '<i class=\"fas fa-play\"></i>'
      })
      .catch((_err) => {
        this.runTarget.innerHTML = '<i class=\"fas fa-play\"></i>'
      })
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
