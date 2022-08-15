import consumer from "./consumer"

$(document).on('turbolinks:load', function() {

  const questionId = $('.question').data('questionId');

  if (questionId != null) {
    consumer.subscriptions.create({
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
          if (gon.authorId != data.answer.author_id) {
            $('.answers-list').append(renderAnswer(data));
          }
        }
      });

    function renderAnswer(data) {
      let files = '';

      if (data.files.length > 0) {
        files += '<ul>';

        $.each(data.files, (index, value) => {
          files += `
          <li id="file-${value.id}">
            <p>
              <a href="${value.url}">${value.name}</a>
            </p>
          </li>
          `;
        });

        files += '</ul>';
      }

      let links = '';

      if (data.files.length > 0) {
        links += '<ul>';

        $.each(data.links, (index, value) => {
          links += `
          <li id="link-${value.id}">
            <div>
              <a href=${value.url}>${value.name}</a>
            </div>
          </li>
          `;
        });

        links += '</ul>';
      }

      const template = `
        <div class="answer" id="answer-${data.answer.id}">
          <hr>
          <p>
            ${data.answer.text}
          </p>
          <div class="votes">
            <a data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/${data.answer.id}/vote_up">+</a> <span class="rating">0</span> <a data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/${data.answer.id}/vote_down">-</a>
          </div>
          <div class="answer-files">
            ${files}
          </div>
          <div class="answer-links">
            <p>
              Links:
            </p>
            ${links}
          </div>
        </div>
      `;

      return template;
    }
  }

});
