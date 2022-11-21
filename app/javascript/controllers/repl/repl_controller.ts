import { Controller } from "@hotwired/stimulus"
import * as monaco from "monaco-editor/esm/vs/editor/editor.api.js"
import hotkeys from "hotkeys-js"

export default class extends Controller {
  static targets = ["editorContainer", "resultsWindow", "playButton", "versionSelector"]

  declare readonly editorContainerTarget: HTMLElement
  declare readonly resultsWindowTarget: HTMLElement
  declare readonly playButtonTarget: HTMLElement
  declare readonly versionSelectorTarget: HTMLSelectElement
  declare executeShortcut: string
  declare editor: monaco.editor.IStandaloneCodeEditor

  initialize () {
    this.executeShortcut = "ctrl+enter,cmd+k"
  }

  connect () {
    hotkeys("ctrl+enter,cmd+enter", (event, handler) => {
      event.preventDefault()
      this.execute()
    })

    this.editor = monaco.editor.create(this.editorContainerTarget, {
      value: "puts \"Hello from #{RUBY_ENGINE} #{RUBY_VERSION} 👋\"",
      language: "ruby",
      minimap: {
        enabled: false
      },
      automaticLayout: true,
      fontSize: 16,
      scrollBeyondLastLine: false,
      hideCursorInOverviewRuler: true,
      renderLineHighlight: "none",
      renderLineHighlightOnlyWhenFocus: false,
      overviewRulerBorder: false
    })

    this.editor.addCommand(monaco.KeyMod.chord(monaco.KeyMod.CtrlCmd, monaco.KeyCode.Enter), () => {
      this.execute()
    })
  }

  disconnect () {
    hotkeys.unbind(this.executeShortcut)
  }

  execute () {
    this.playButtonTarget.innerHTML = `
    <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>
    `

    const versionSlug = this.versionSelectorTarget.value.split("-")
    const engine = versionSlug[0]
    const version = versionSlug[1]

    fetch("/run", {
      method: "POST",
      body: JSON.stringify({
        snippet: this.editor.getValue(),
        version,
        engine
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
        const output = data.output.concat("\n", data.error)
        this.resultsWindowTarget.innerHTML = output
      })
      .finally(() => {
        this.playButtonTarget.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" />
      </svg>
      `
      })
  }
}
