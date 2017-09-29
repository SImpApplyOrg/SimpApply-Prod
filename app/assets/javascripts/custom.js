$(document).on('turbolinks:load', function() {
  $('.job_application_question, .job_application_question_no').on('click', '.hover-edit', function(){
    $(this).siblings('.question-form').toggle();
    $(this).siblings('.question-form').find('input.table-input-width, select.table-input-width').focus();
    $(this).toggle();
  });

  $('.job_application_question').on('focusout', '.question-title', function() {
    $(this).parent().submit();
  });

  $('.job_application_question_no').on('change', '.question-no', function() {
    $(this).parent().submit();
  });

  $('.tag_links').on('click',function(){
    var link_value = $(this).text();
    var $txt = $("#response_message_message");
    var caretPos = $txt[0].selectionStart;
    var textAreaTxt = $txt.val();
    var txtToAdd = " {{" + link_value + "}}";
    $txt.val(textAreaTxt.substring(0, caretPos) + txtToAdd + textAreaTxt.substring(caretPos) );
  });

});
