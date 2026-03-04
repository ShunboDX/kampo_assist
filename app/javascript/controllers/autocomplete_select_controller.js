import { Controller } from "@hotwired/stimulus"

// 目的：入力→候補表示→クリックで対象チェックボックスをON + 任意でスクロール
export default class extends Controller {
  static targets = ["input", "list"]
  static values = { url: String, debounce: Number }

  connect() {
    this.timer = null
    this.composing = false
    if (!this.hasDebounceValue) this.debounceValue = 200
  }

  // IME対策
  compositionstart() { this.composing = true }
  compositionend() { this.composing = false; this.search() }

  input() {
    if (this.composing) return
    this.search()
  }

  search() {
    window.clearTimeout(this.timer)
    this.timer = window.setTimeout(() => this.fetchSuggestions(), this.debounceValue)
  }

  async fetchSuggestions() {
    const q = this.inputTarget.value.trim()
    if (!q) {
      this.render([])
      return
    }

    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set("q", q)

    const res = await fetch(url.toString(), { headers: { Accept: "application/json" } })
    if (!res.ok) return this.render([])

    const data = await res.json()
    this.render(data)
  }

  render(items) {
    this.listTarget.innerHTML = ""

    if (!items.length) {
      this.listTarget.classList.add("hidden")
      return
    }

    this.listTarget.classList.remove("hidden")

    for (const item of items) {
      const btn = document.createElement("button")
      btn.type = "button"
      btn.className =
        "w-full text-left px-3 py-2 text-sm hover:bg-slate-50 rounded-lg"
      btn.textContent = item.name
      btn.dataset.id = item.id
      btn.addEventListener("click", () => this.pick(item))
      this.listTarget.appendChild(btn)
    }
  }

  pick(item) {
    // チェックボックスをONにする（id規則に合わせて探す）
    const checkbox = document.getElementById(`${this.element.dataset.checkboxPrefix}_${item.id}`)
    if (checkbox) {
      checkbox.checked = true
      // 変更イベントを発火（必要なら auto-submit と連携可能）
      checkbox.dispatchEvent(new Event("change", { bubbles: true }))

      // 見える位置へ
      checkbox.scrollIntoView({ block: "center", behavior: "smooth" })
    }

    // 入力欄は残す/消すは好み。ここは消す方が気持ちいいことが多い
    this.inputTarget.value = ""
    this.render([])
  }
}