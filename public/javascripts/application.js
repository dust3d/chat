if (navigator.userAgent.match(/Mobile|WebOS/i)) var mobile = true;
var env;

$(function() {
  $('#post_message').keypress(function(){
    $(this).removeAttr('style');
    $('.error').hide();
    $('.loading').hide();
  });
  
  $('#new_post').submit(function(e) {
    e.preventDefault();
    
    var msg = $('#post_message').val();
    if (msg !== "") {
      $('.loading').show();
      $(this).request(function(response) {
        $('#post_message').val('');
        $('.loading').fadeOut('fast');
      }); 
    } else {
      $('#post_message').css({
        'border-color': 'red'
      }).focus();
      $('.error').show();
    }
  });
  
  env = $('#rails_env').data('value');

  var pusher = new Pusher('534d197146cf867179ee');
  var channel = pusher.subscribe('groupon_go_' + env);

  pusher.bind('new_post',
    function(data) {
      var tmpl = MustacheTemplates['posts/_post'];
      var post = {
        profile_image_url: data.profile_image_url,
        twitter_login: data.twitter_login,
        name: data.name,
        login: data.twiter_login,
        message: data.body,
        time_ago: 'less than a minute'
      };
      $('#chat_data').prepend(Mustache.to_html(tmpl, post));
    }
  );
  
  $('#post_message').focus();

  $("#post_message").keyup(function(e){
    if($(this).val().match(/@[\S]+/i)){
      var q = $(this).val().match(/(?:@)([\S]+)/i)[1];
      $.get('/users.json?q=' + q, function(data){
        var current_val = $('#post_message').val();
        $('#post_message').val(current_val.replace(q, data[0].name));
      });
    }
  });
  
});

(function($) {
  $.fn.request = function(success) {
    var jqopts = {
      url: this.attr('action'),
      type: this.attr('method') || 'GET',
      data: this.serialize(),
      complete: success
    };
    $.ajax(jqopts);
  };
})(jQuery);


// Get users loction and set latitude and longitude to hidden input 
// in form
if (navigator.geolocation) 
{
  navigator.geolocation.getCurrentPosition( 

    function (position) {  

      // Did we get the position correctly?
      // alert (position.coords.latitude);

      // To see everything available in the position.coords array:
      // for (key in position.coords) {alert(key)}

      // alert(position.coords.latitude,position.coords.longitude);
      $("#lat").val(position.coords.latitude);
      $("#lon").val(position.coords.longitude);
    }, 
    // next function is the error callback
    function (error)
    {
      switch(error.code) 
      {
        case error.TIMEOUT:
        // alert ('Timeout');
        break;
        case error.POSITION_UNAVAILABLE:
        // alert ('Position unavailable');
        break;
        case error.PERMISSION_DENIED:
        // alert ('Permission denied');
        break;
        case error.UNKNOWN_ERROR:
        // alert ('Unknown error');
        break;
      }
    }
  );
}
