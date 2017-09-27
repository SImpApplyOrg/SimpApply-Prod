$(document).on('turbolinks:load', function() {
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
    var $txt = $("#response_message_message");
    var caretPos = $txt[0].selectionStart;
    var textAreaTxt = $txt.val();
    var txtToAdd = " {{" + link_value + "}}";
    $txt.val(textAreaTxt.substring(0, caretPos) + txtToAdd + textAreaTxt.substring(caretPos) );
  });

});
