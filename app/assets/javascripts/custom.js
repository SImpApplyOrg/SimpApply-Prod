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

  $(document).on('focusout', '#user_organization_name', function() {
    $(this).parents('form.organization_name_form').submit();
  });

  if($('.organization-names').length > 0) {
    if($('.organization-names li a[is_active=true]').length == 0){
      set_organization_name($('.organization-names li:first a'));
    } else {
      set_organization_name($('.organization-names li a[is_active=true]').first());
    }
  }

  $('.organization-names').on('click', 'a', function(){
    set_organization_name($(this));

    $.get('/set_organization', { merchant_id: $(this).data('user_id') });
  });

  function set_organization_name(obj) {
    var $link = $('.organization-name');
    var $span = $link.find('span');
    $link.html(obj.text()+ " ");
    $link.append($span);
  }

  $('#show_organization_model').on('click',function(){
    $('.modal-organization-name').show();
    $('.modal-footer').hide();
  });

  $('#organization_name').on('mouseover', function() {
    $(this).children('a').toggle();
  });

  $('#organization_name').on('mouseout', function() {
    $(this).children('a').toggle();
  });

  $('.edit-organization-name').on('click', function(){
    $('.modal-organization-name').show();
    $('#organization_modal').modal('show');
  });

});
