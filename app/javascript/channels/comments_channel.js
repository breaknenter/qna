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

        received(comment) {
          if(comment.commentable_type == 'Question') {
            $('#question-comments').append(renderComment(comment));
            console.log(renderComment(comment));
          } else if (comment.commentable_type == 'Answer') {
            $(`answer-comments-${comment.commentable_id}`).append(renderComment(comment));
          }
        }
      });

    function renderComment(comment) {
      let template = `
      <p>
        <small>${comment.text}</small>
      </p>
      `;

      return template;
    }
  }

});
