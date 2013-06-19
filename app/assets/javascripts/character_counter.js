$(function() {
  if($('.grit-body').length) {
    $('.grit-body').on('keyup', function(e) {
      var remaining_chars = 140 - $('.grit-body').val().length;
      $('.count').text((remaining_chars) + " ");
      $('.counter').toggleClass('over', (remaining_chars < 0));
    });
  }
});
