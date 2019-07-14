import { Controller } from "stimulus"
import tippy from "tippy.js"

export default class extends Controller {
  static targets = ["objectType", "githubLink"]

  connect() {
    tippy([this.objectTypeTarget, this.githubLinkTarget])
  }
}
