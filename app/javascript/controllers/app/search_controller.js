import { Controller } from "@hotwired/stimulus"
import { throttle } from "lodash"
import hotkeys from "hotkeys-js"
import mustache from "mustache"

export default class extends Controller {
  static targets = ["input", "autocomplete", "button"]

  initialize () {
    this.searchHotKey = "/"
    this.autocompleteTemplate = `
    <ul class="lg:px-2 py-2 text-gray-800 overflow-auto">
      {{#results}}
      <li class="my-2 py-1 px-2 rounded hover:bg-gray-200">
        <a href="{{path}}" class="w-full inline-block whitespace-nowrap">
          <svg xmlns="http://www.w3.org/2000/svg" class="inline h-5 w-5" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" /></svg>
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

    this.autocomplete = throttle(this.autocomplete, 300)
    this.lastQuery = ""
    this.suggestionIndex = 0
  }

  connect () {
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

    this.autocompleteTarget.addEventListener("mousemove", () => {
      this.clearSelectedSuggestion()
      this.suggestionIndex = 0
    })

    window.addEventListener("mousedown", (e) => {
      if (!this.autocompleteTarget.contains(e.target)) { return }

      let link = e.target
      if (link.tagName !== "A") { link = e.target.parentElement }

      if (link.tagName !== "A") { return }

      window.location.assign(link.href)
    })
  }

  disconnect () {
    hotkeys.unbind(this.searchHotKey)
    this.inputTarget.removeEventListener("focusin")
    this.inputTarget.removeEventListener("blur")
    this.autocompleteTarget.removeEventListener("mousemove")
    window.removeEventListener("mousedown")
  }

  async onKeyup (event) {
    const query = this.inputTarget.value
    const version = this.data.get("version")
    const path = this.data.get("url")

    if (query.length === 0) {
      this.autocompleteTarget.innerHTML = ""
      return
    }

    if (this.lastQuery === query) {
      return
    }

    this.lastQuery = query

    await this.autocomplete(query, version, path)
  }

  async onKeydown (event) {
    if (event.key.startsWith("Arrow")) {
      this.handleArrowKey(event)
    } else if (event.key === "Enter" && this.suggestionIndex !== 0) {
      event.preventDefault()
      this.getSelectedSuggestion().querySelector("a").click()
    }
  }

  handleArrowKey (event) {
    this.clearSelectedSuggestion()

    if (event.key === "ArrowUp") {
      event.preventDefault()
      this.suggestionIndex -= 1
    } else if (event.key === "ArrowDown") {
      event.preventDefault()
      this.suggestionIndex += 1
    }

    const max = this.suggestionsLength()
    this.suggestionIndex = this.wrap(this.suggestionIndex, max)

    this.highlightSelectedSuggestion()
  }

  async autocomplete (query, version, path) {
    this.suggestionIndex = 0

    const queryParam = new URLSearchParams({ q: query })
    const url = `${path}?${queryParam.toString()}`

    fetch(url, {
      method: "get",
      headers: {
        "Content-Type": "application/json"
      }
    })
      .then((response) => { return response.json() })
      .then((results) => {
        const render = mustache.render(this.autocompleteTemplate, {
          results
        })
        this.autocompleteTarget.innerHTML = render
      })
      .catch(() => {

      })
  }

  wrap (value, max) {
    return value < 0 ? max : (value > max ? 0 : value)
  }

  suggestionsLength () {
    return this.autocompleteTarget.querySelectorAll("li").length
  }

  getSelectedSuggestion () {
    return this.autocompleteTarget.querySelector(`li:nth-child(${this.suggestionIndex})`)
  }

  clearSelectedSuggestion () {
    const suggestion = this.getSelectedSuggestion()
    if (suggestion) {
      suggestion.classList.remove("bg-gray-200")
    }
  }

  highlightSelectedSuggestion () {
    const suggestion = this.getSelectedSuggestion()
    if (suggestion) {
      suggestion.classList.add("bg-gray-200")
    }
  }
}
