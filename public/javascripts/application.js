if (navigator.userAgent.match(/Mobile|WebOS/i)) var mobile = true;

$(function() {
  $('#chat_input').keypress(function(){
    $(this).removeAttr('style');
    $('.error').hide();
    $('.loading').hide();
  });
  
  $('#message_post_form').submit(function(e) {
    e.preventDefault();
    
    var msg = $('#chat_input').val();
    if (msg !== "") {
      $('.loading').show();
      $(this).request(function(response) {
        $('#chat_input').val('');
        $('.loading').fadeOut('fast');
      }); 
    } else {
      $('#chat_input').css({
        'border-color': 'red'
      }).focus();
      $('.error').show();
    }
  });
  
  $('#chat_input').focus();
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

var pusher = new Pusher('534d197146cf867179ee');

var channel = pusher.subscribe('groupon_go');

pusher.bind('new_post',
  function(data) {
    var tmpl = MustacheTemplates['chats/_post'];
    var post = {
      profile_image_url: data.profile_image_url,
			twitter_login: data.twitter_login,
      name: data.name,
      chat_input: data.body,
      time_ago: 'less than a minute'
    };
    if (mobile) {
      $('#chat_data').append(Mustache.to_html(tmpl, post));
    } else {
      $('#chat_data').prepend(Mustache.to_html(tmpl, post));
    }
    
  }
);

