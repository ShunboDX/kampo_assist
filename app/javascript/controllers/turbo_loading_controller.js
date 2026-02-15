import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  connect() {
    this.onBeforeFetchRequest = this.onBeforeFetchRequest.bind(this)
    this.onFrameLoad = this.onFrameLoad.bind(this)
    this.onFrameFetchRequestError = this.onFrameFetchRequestError.bind(this)

    document.addEventListener("turbo:before-fetch-request", this.onBeforeFetchRequest)
    document.addEventListener("turbo:frame-load", this.onFrameLoad)
    document.addEventListener("turbo:frame-fetch-request-error", this.onFrameFetchRequestError)
  }

  disconnect() {
    document.removeEventListener("turbo:before-fetch-request", this.onBeforeFetchRequest)
    document.removeEventListener("turbo:frame-load", this.onFrameLoad)
    document.removeEventListener("turbo:frame-fetch-request-error", this.onFrameFetchRequestError)
  }

  onBeforeFetchRequest(event) {
    const frame = event.target
    if (frame?.id !== "search_step_frame") return
    this.show()
  }

  onFrameLoad(event) {
    const frame = event.target
    if (frame?.id !== "search_step_frame") return
    this.hide()
  }

  onFrameFetchRequestError(event) {
    const frame = event.target
    if (frame?.id !== "search_step_frame") return
    this.hide()
  }

  show() {
    this.overlayTarget.classList.remove("hidden")
  }

  hide() {
    this.overlayTarget.classList.add("hidden")
  }
}