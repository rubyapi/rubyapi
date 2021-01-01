import { Controller } from "stimulus"
import throttle from "lodash/throttle"
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

    this.throttledAutocomplete = throttle(this.autocomplete, 300)
    this.lastQuery = ""
  }

  connect() {
    hotkeys(this.searchHotKey, (event, handler) => {
      event.preventDefault()
      this.inputTarget.focus()
    })

    this.inputTarget.addEventListener("focusin", () => {
      this.buttonTarget.classList.add("text-gray-700")
      this.autocompleteTarget.classList.remove("hidden")
    })

    this.inputTarget.addEventListener("focusout", () => {
      this.autocompleteTarget.classList.add("hidden")
      this.buttonTarget.classList.remove("text-gray-700")
    })

    window.addEventListener("mousedown", (e) => {
      if(!this.autocompleteTarget.contains(e.target))
        return

      let link = e.target
      if (link.tagName != "A")
        link = e.target.parentElement

      if(link.tagName != "A")
        return

      window.location.assign(link.href);
    })
  }

  disconnect() {
    hotkeys.unbind(this.searchHotKey)
    this.inputTarget.removeEventListener("focusin")
    this.inputTarget.removeEventListener("blur")
    window.removeEventListener("mousedown")
  }

  async autocomplete() {
    const query = this.inputTarget.value
    const version = this.data.get("version")
    const path = this.data.get("url")

    if (query.length == 0) {
      this.autocompleteTarget.innerHTML = ""
      return
    }

    if (this.lastQuery === query) {
      return
    }

    this.lastQuery = query

    fetch(path, {
      method: "post",
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        query: `
        query GetAutocompleteResults($query: String!, $version: String = "2.6") {
          autocomplete(query: $query, version: $version) {
            text
            path
          }
        }`,
        variables: { query, version }
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
