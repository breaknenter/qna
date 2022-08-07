import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  if (this.subscription) {
    consumer.subscriptions.remove(this.subscription);
    this.subscription = null;
    consumer.disconnect();

    console.log("Remove subscription and disconnect");
  }

  if (document.getElementById("questions-list")) {
    this.subscription = consumer.subscriptions.create({
      channel: "QuestionsChannel"
    },

    {
      connected() {
        this.perform("subscribed");
        console.log("Connected to QuestionsChannel");
      },

      disconnected() {
        console.log("Disconnected from QuestionsChannel");
      },

      received(data) {
      }
    });
  }

});
