import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  if (this.subscription) {
    consumer.subscriptions.remove(this.subscription);
    this.subscription = null;
    consumer.disconnect();

    console.log("Remove subscription and disconnect");
  }

  const questionId = $('.question').data('questionId');

  if (questionId != null) {
    this.subscription = consumer.subscriptions.create({
        channel: "AnswersChannel",
        question_id: questionId
      },

      {
        connected() {
          console.log("Connected to AnswersChannel");
        },

        disconnected() {
          console.log("Disconnected from AnswersChannel");
        },

        received(data) {
        }

      });
  }

});
