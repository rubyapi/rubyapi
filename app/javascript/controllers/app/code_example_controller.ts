import { Controller } from "@hotwired/stimulus"
import copy from "clipboard-copy"

export default class extends Controller {
  static targets: string[] = ["block", "copy", "run"]

  declare readonly blockTarget: HTMLDivElement
  declare readonly copyTarget: HTMLSpanElement
  declare readonly runTarget: HTMLSpanElement

  connect () {
    const codeBar = document.createElement("div")
    codeBar.classList.add("w-full", "px-3", "py-2", "bg-code-header", "dark:bg-gray-700", "items-center", "flex", "justify-between", "font-mono", "rounded-t")
    codeBar.innerHTML = "<span class=\"text-gray-300 text-sm\">Example</span><div><button class=\"px-2\" title=\"Run code\" aria-label=\"Run code\" data-action=\"click->code-example#run\"><span class=\"text-gray-300 fill-current hover:text-gray-500\" data-code-example-target=\"run\"><svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-5 w-5\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path fill-rule=\"evenodd\" d=\"M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z\" clip-rule=\"evenodd\" /></svg></span></button><button title=\"Copy to clipboard\" class=\"pl-2\" data-action=\"click->code-example#copy\" aria-label=\"Copy to clipboard\"><span data-code-example-target=\"copy\" class=\"text-gray-300 fill-current hover:text-gray-500\"><svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-5 w-5\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path d=\"M8 3a1 1 0 011-1h2a1 1 0 110 2H9a1 1 0 01-1-1z\" /><path d=\"M6 3a2 2 0 00-2 2v11a2 2 0 002 2h8a2 2 0 002-2V5a2 2 0 00-2-2 3 3 0 01-3 3H9a3 3 0 01-3-3z\" /></svg></span></button></div>"

    this.blockTarget.append(codeBar)
  }

  run () {
    const snippet = this.element.nextElementSibling
    const version = this.data.get("version")
    this.runTarget.innerHTML = "<svg class=\"animate-spin h-5 w-5\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 512 512\"><path fill=\"currentColor\" d=\"M440.65 12.57l4 82.77A247.16 247.16 0 0 0 255.83 8C134.73 8 33.91 94.92 12.29 209.82A12 12 0 0 0 24.09 224h49.05a12 12 0 0 0 11.67-9.26 175.91 175.91 0 0 1 317-56.94l-101.46-4.86a12 12 0 0 0-12.57 12v47.41a12 12 0 0 0 12 12H500a12 12 0 0 0 12-12V12a12 12 0 0 0-12-12h-47.37a12 12 0 0 0-11.98 12.57zM255.83 432a175.61 175.61 0 0 1-146-77.8l101.8 4.87a12 12 0 0 0 12.57-12v-47.4a12 12 0 0 0-12-12H12a12 12 0 0 0-12 12V500a12 12 0 0 0 12 12h47.35a12 12 0 0 0 12-12.6l-4.15-82.57A247.17 247.17 0 0 0 255.83 504c121.11 0 221.93-86.92 243.55-201.82a12 12 0 0 0-11.8-14.18h-49.05a12 12 0 0 0-11.67 9.26A175.86 175.86 0 0 1 255.83 432z\"></path></svg>"

    fetch("/run", {
      method: "POST",
      body: JSON.stringify({
        snippet: snippet?.textContent,
        version
      }),
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        "X-Requested-With": "XMLHttpRequest"
      },
      cache: "no-cache",
      credentials: "same-origin"
    })
      .then((response) => response.json())
      .then((data) => {
        const resultDiv = document.createElement("pre")
        const output = "<span class=\"absolute top-0 right-0 m-2 px-2 py-1 bg-gray-400 dark:bg-gray-800 dark:text-gray-200 rounded text-sm\"><svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-5 w-5\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path fill-rule=\"evenodd\" d=\"M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z\" clip-rule=\"evenodd\" /></svg> Experimental Feature</span>"
        resultDiv.classList.add("w-full", "my-2", "p-3", "rounded", "bg-gray-300", "text-gray-700", "dark:bg-gray-900", "dark:text-gray-200", "font-mono", "relative")

        resultDiv.innerHTML = output.concat(data.output)
        snippet?.insertAdjacentElement("afterend", resultDiv)

        this.runTarget.innerHTML = "<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-5 w-5\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path fill-rule=\"evenodd\" d=\"M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z\" clip-rule=\"evenodd\" /></svg>"
      })
      .catch((_err) => {
        this.runTarget.innerHTML = "<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-5 w-5\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path fill-rule=\"evenodd\" d=\"M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z\" clip-rule=\"evenodd\" /></svg>"
      })
  }

  copy () {
    const snippet = this.element.nextElementSibling
    copy(snippet?.textContent || "")
      .then(() => {
        this.copyTarget.innerHTML = "<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-5 w-5\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path fill-rule=\"evenodd\" d=\"M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z\" clip-rule=\"evenodd\" /></svg>"
        setTimeout(() => {
          this.copyTarget.innerHTML = "<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-5 w-5\" viewBox=\"0 0 20 20\" fill=\"currentColor\"><path d=\"M8 2a1 1 0 000 2h2a1 1 0 100-2H8z\" /><path d=\"M3 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v6h-4.586l1.293-1.293a1 1 0 00-1.414-1.414l-3 3a1 1 0 000 1.414l3 3a1 1 0 001.414-1.414L10.414 13H15v3a2 2 0 01-2 2H5a2 2 0 01-2-2V5zM15 11h2a1 1 0 110 2h-2v-2z\" /></svg>"
        }, 3000)
      })
  }
}
