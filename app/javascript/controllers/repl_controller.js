import { Controller } from "stimulus"
import * as monaco from "monaco-editor"
import hotkeys from "hotkeys-js"

export default class extends Controller {
  static targets = ["editorContainer", "resultsWindow", "playButton", "versionSelector"]

  initialize() {
    this.executeShortcut = "ctrl+enter,cmd+k"
  }

  connect() {
    hotkeys("ctrl+enter,cmd+enter", (event, handler) => {
      event.preventDefault()
      this.execute()
    })

    this.editor = monaco.editor.create(this.editorContainerTarget, {
      value: "puts \"Hello World!\"",
      language: 'ruby',
      minimap: {
        enabled: false
      },
      automaticLayout: true,
      fontSize: '16px',
      scrollBeyondLastLine: false,
      hideCursorInOverviewRuler: true,
      renderLineHighlight: 'none',
      renderLineHighlightOnlyWhenFocus: false,
      overviewRulerBorder: false,
    })

    this.editor.addCommand(monaco.KeyMod.chord(monaco.KeyMod.CtrlCmd | monaco.KeyCode.Enter), () => {
      this.execute()
    })
  }
  
  disconnect() {
    hotkeys.unbind(this.executeShortcut)
  }

  execute() {
    this.playButtonTarget.innerHTML = '<i class=\"fas fa-sync fa-spin\"></i>'

    const versionSlug = this.versionSelectorTarget.value.split("-")
    const engine = versionSlug[0]
    const version = versionSlug[1]

    fetch("/run", {
      method: 'POST',
      body: JSON.stringify({
        snippet: this.editor.getValue(),
        version: version,
        engine: engine,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
      cache: 'no-cache',
      credentials: "same-origin"
    })
    .then((response) => response.json())
    .then((data) => {
      const output = data.output.concat("\n", data.error)
      this.resultsWindowTarget.innerHTML = output
    })
    .finally(() => {
      this.playButtonTarget.innerHTML = '<i class=\"fas fa-play\"></i>'
    })
  }
}
