import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const form = this.element.querySelector("form");
    form.addEventListener("submit", () => {
      setTimeout(() => {
        this.element.querySelector("#message_body").value = "";
      });
    });
  }
}
