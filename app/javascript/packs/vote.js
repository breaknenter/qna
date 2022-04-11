$(document).on('turbolinks:load', () => {

  $('.votes').on('ajax:success', function(event) {
    const rating = event.detail[0].rating;

    $(this).find('.rating').text(rating);
  }).on('ajax:error', (event) => {
    const errors = event.detail[0].errors;

    $.each(errors, function(index, value) {
      alert(value);
    });
  });

});
