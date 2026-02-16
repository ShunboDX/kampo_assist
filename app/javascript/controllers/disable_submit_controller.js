import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.onSubmitStart = this.onSubmitStart.bind(this)
    this.onSubmitEnd = this.onSubmitEnd.bind(this)

    // Turboのフォーム送信イベント（フルページ/フレーム両方で使える）
    document.addEventListener("turbo:submit-start", this.onSubmitStart)
    document.addEventListener("turbo:submit-end", this.onSubmitEnd)
  }

  disconnect() {
    document.removeEventListener("turbo:submit-start", this.onSubmitStart)
    document.removeEventListener("turbo:submit-end", this.onSubmitEnd)
  }

  onSubmitStart(event) {
    // この controller が付いているフォームだけを対象にする
    if (event.target !== this.element) return

    this.buttonTargets.forEach((btn) => {
      if (btn.disabled) return

      // 元テキストを退避
      btn.dataset.originalText ||= btn.innerText
      btn.disabled = true
      btn.setAttribute("aria-disabled", "true")
      btn.classList.add("opacity-60", "cursor-not-allowed")

      // 表示文言を変更（任意）
      const loadingText = btn.dataset.loadingText || "送信中…"
      btn.innerText = loadingText
    })
  }

  onSubmitEnd(event) {
    if (event.target !== this.element) return

    this.buttonTargets.forEach((btn) => {
      btn.disabled = false
      btn.removeAttribute("aria-disabled")
      btn.classList.remove("opacity-60", "cursor-not-allowed")

      // 文言を戻す
      if (btn.dataset.originalText) btn.innerText = btn.dataset.originalText
    })
  }
}