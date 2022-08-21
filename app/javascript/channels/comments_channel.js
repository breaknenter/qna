import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  const questionId = $('.question').data('questionId');

  if (questionId != null) {
    consumer.subscriptions.create({
        channel: "CommentsChannel",
        question_id: questionId
      },

      {
        connected() {
          console.log("Connected to CommentsChannel");
        },

        disconnected() {
          console.log("Disconnected from CommentsChannel");
        },

        received(data) {
          if (gon.authorId != data.answer.author_id) {
            $('#question-comments').append(renderComment(data));
          }
        }
      });

    function renderComment(data) {
    }
  }

});
