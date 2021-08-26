$(document).on('turbolinks:load', () => {
  $('.question-edit-link').on('click', function(event) {
    event.preventDefault();
    $(this).hide();
    $(`form.question-edit`).removeClass('hidden');
  })
});
