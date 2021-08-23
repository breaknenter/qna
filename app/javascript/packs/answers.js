$(document).on('turbolinks:load', () => {
  $('.answers-list').on('click', '.answers-edit-link', function(event) {
    event.preventDefault();
    $(this).hide();

    const answerId = $(this).data('answerId');
    $(`form#edit-answer-${answerId}`).removeClass('hidden');
  })
});
