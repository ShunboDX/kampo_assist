// app/javascript/controllers/auto_submit_controller.js
import { Controller } from "@hotwired/stimulus"

// data-controller="auto-submit" が付いた要素（ここでは form）に対するコントローラ
export default class extends Controller {
  submit() {
    // このコントローラが紐づいている要素（= form）を送信
    this.element.requestSubmit()
  }
}
