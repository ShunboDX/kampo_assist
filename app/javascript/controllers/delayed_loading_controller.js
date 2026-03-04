import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["indicator"]
  static values = { delay: Number }

  connect() {
    if (!this.hasDelayValue) this.delayValue = 300
    this.timer = null

    this.onStart = this.onStart.bind(this)
    this.onEnd = this.onEnd.bind(this)

    this.element.addEventListener("turbo:submit-start", this.onStart)
    this.element.addEventListener("turbo:submit-end", this.onEnd)
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-start", this.onStart)
    this.element.removeEventListener("turbo:submit-end", this.onEnd)
    this.clearTimer()
    this.hide()
  }

  onStart() {
    this.clearTimer()
    this.hide()
    this.timer = setTimeout(() => this.show(), this.delayValue)
  }

  onEnd() {
    this.clearTimer()
    this.hide()
  }

  clearTimer() {
    if (this.timer) {
      clearTimeout(this.timer)
      this.timer = null
    }
  }

  show() {
    if (this.hasIndicatorTarget) this.indicatorTarget.classList.remove("hidden")
  }

  hide() {
    if (this.hasIndicatorTarget) this.indicatorTarget.classList.add("hidden")
  }
}