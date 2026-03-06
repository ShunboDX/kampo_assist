import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    selector: String,
    submit: Boolean
  }

  clear() {
    const selector = this.hasSelectorValue ? this.selectorValue : 'input[type="checkbox"]'
    const checkboxes = this.element.querySelectorAll(selector)

    checkboxes.forEach((checkbox) => {
      checkbox.checked = false
    })

    if (this.hasSubmitValue && this.submitValue) {
      this.element.requestSubmit()
    }
  }
}