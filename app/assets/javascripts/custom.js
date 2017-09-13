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
});
