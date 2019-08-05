import { Controller } from "stimulus"
import hotkeys from "hotkeys-js"
import mustache from "mustache"

export default class extends Controller {
  static targets = ["input", "autocomplete", "button"]

  initialize() {
    this.searchHotKey = "/"
    this.autocompleteTemplate = `
    <ul class="lg:px-2 py-2 text-gray-800 overflow-auto">
      {{#results}}
      <li class="my-2 py-1 px-2 rounded hover:bg-gray-200">
        <a href="{{path}}" class="w-full inline-block whitespace-no-wrap">
          <i class="fas fa-search h-3"></i>
          <span class="lg:pl-2">{{text}}</span>
        </a>
      </li>
      {{/results}}
      {{^results}}
      <li class="my-2 py-1 px-2">
        No Results
      </li>
      {{/results}}
    </ul>
  `
  }

  connect() {
    const element = this.inputTarget
    hotkeys(this.searchHotKey, (event, handler) => {
      event.preventDefault()
      element.focus()
    })

    this.inputTarget.addEventListener("focusin", () => {
      this.buttonTarget.classList.add("text-gray-800")
      this.autocompleteTarget.hidden = false
    })

    this.inputTarget.addEventListener("blur", (e) => {
      this.buttonTarget.classList.remove("text-gray-800")

      setTimeout(() => {
        this.autocompleteTarget.hidden = true
      }, 100)
    })
  }

  disconnect() {
    hotkeys.unbind(this.searchHotKey)
    this.inputTarget.removeEventListener("focusin")
    this.inputTarget.removeEventListener("blur")
  }

  async autocomplete() {
    const query = this.inputTarget.value
    const version = this.data.get("version")
    const path = this.data.get("url")

    fetch(path, {
      method: "post",
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        query: `
          {
            autocomplete(query: "${query}", version: "${version}") {
              text
              path
            }
          }
        `
      })
    })
      .then((response) => { return response.json() })
      .then((results) => {
        const render = mustache.render(this.autocompleteTemplate, {
          results: results.data.autocomplete
        })
        this.autocompleteTarget.innerHTML = render
      })
      .catch(() => {

      })
  }
}
