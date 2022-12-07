import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = {
    sharingId: Number,
    currentUserId: Number
  }
  static targets = ["messages"]

  connect() {
    console.log(this.sharingIdValue);
    setTimeout(() => {
      this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
    }, 0.001);
    this.channel = createConsumer().subscriptions.create(
      { channel: "SharingChannel", id: this.sharingIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }
    )
    // console.log(`Subscribed to the sharing with the id ${this.sharingIdValue}.`)
  }

  #insertMessageAndScrollDown(data) {
    console.log('hello there')
    // this.messagesTarget.insertAdjacentHTML("beforeend", data.message_html)
    // this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
    const currentUserIsSender = this.currentUserIdValue === data.sender_id
    const messageElement = this.#buildMessageElement(currentUserIsSender, data.message_html)
    this.messagesTarget.insertAdjacentHTML("beforeend", messageElement)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
  }

  #buildMessageElement(currentUserIsSender, message) {
    return message
  }

  #justifyClass(currentUserIsSender) {
    return currentUserIsSender ? 'flex-row-reverse justify-content-end' : 'justify-content-start'
  }

  #userStyleClass(currentUserIsSender) {
    return currentUserIsSender ? "sender-style" : "receiver-style"
  }

  resetForm(event) {
    event.target.reset()
  }

  disconnect() {
    // console.log("Unsubscribed from the sharing")
    this.channel.unsubscribe()
  }
}
