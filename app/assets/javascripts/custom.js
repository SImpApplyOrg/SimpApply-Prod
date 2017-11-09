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

  $( ".sortable" ).sortable({
    stop: function(event, ui) {
      $(this).find('.form-group').each(function(i, el){
        $(this).find('input.tab_field_position').val(i+1);
      });
    }
  });
  $( ".sortable" ).disableSelection();

  $(document).on('nested:fieldAdded', function(event) {
    $(".sortable").sortable();
  });

  if($('.organization-names').length > 0) {
    if($('.organization-names li a[is_active=true]').length == 0){
      set_organization_name($('.organization-names li:first a'));
    } else {
      set_organization_name($('.organization-names li a[is_active=true]').first());
    }
  } else if($('.current_organization').length > 0) {
    $.get('/set_organization', { organization_user_id: $('.current_organization').attr('id') });
  }

  $('.organization-names').on('click', 'a', function(){
    set_organization_name($(this));
  });

  function set_organization_name(obj) {
    var $link = $('.organization-name');
    var $span = $link.find('span');
    $link.html(obj.text()+ " ");
    $link.append($span);

    if(obj.attr('is_active') != "true" && obj.data('user_id') != undefined && obj.data('user_id') != '') {
      $.get('/set_organization', { organization_user_id: obj.data('user_id') });
    }

    $('.organization-names li a').each(function(){
      $(this).attr('is_active', 'false');
    });

    obj.attr('is_active', 'true')
  }

});
