import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  connect() {
    this.escapeHandler = (event) => {
      if (event.key === "Escape") this.close()
    }
    document.addEventListener("keydown", this.escapeHandler)
  }

  disconnect() {
    document.removeEventListener("keydown", this.escapeHandler)
  }

  open(event) {
    event?.preventDefault()
    this.overlayTarget.classList.add("modal-open")
    document.body.style.overflow = "hidden"
  }

  close(event) {
    event?.preventDefault()
    this.overlayTarget.classList.remove("modal-open")
    document.body.style.overflow = ""
  }

  closeOnBackdrop(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }
}
