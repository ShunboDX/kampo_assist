import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  disable() {
    // form内のsubmitボタンを全部disable
    const buttons = this.element.querySelectorAll('input[type="submit"], button[type="submit"]')
    buttons.forEach((btn) => { btn.disabled = true })
  }
}
