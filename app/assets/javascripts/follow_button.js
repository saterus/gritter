$(function() {
  var FollowButton = function($container){
    var $buttons = $container.find('.follow, .unfollow');
    $buttons.find('a').on('ajax:success', function(e, data, status) {
      $buttons.toggle();
    });
  }

  $(".follow-button").each(function(i,e){
    new FollowButton($(e));
  });
});
