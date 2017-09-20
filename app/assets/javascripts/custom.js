$(document).ready(function() {
  $('.job_application_question').on('click', '.hover-edit', function(){
    $(this).siblings('.question-form').toggle();
    $(this).toggle();
  });

  $('.job_application_question').on('focusout', '.question-title', function() {
    if ($(this).val() != "") {
      $(this).parent().submit();
    }
  });

  $('.tag_links').on('click',function(){
    var link_value = $(this).text();
    var msg_box = $("#response_message_message");
    msg_box.val(msg_box.val() + " " + link_value);
  });

});
