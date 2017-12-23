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

  $('.organization-names').on('change', '.organization-radio', function(){
    set_organization_name($(this));
  });

  function set_organization_name(obj) {
    $.get('/set_organization', { organization_user_id: obj.val() } );
  }

  $(function() {
    var tabCount,
      min_screen_tab_count = 1;

    function toggleRemoveLink() {
      $('.screen_tabs_present').children('.screen_tab_remove').toggle(tabCount > min_screen_tab_count)
    }

    $(document).on('nested:fieldAdded', function(e) {
      var check_add_screen_tab  = $(e.currentTarget.activeElement).hasClass('add_new_tab');
      if (check_add_screen_tab){
        tabCount += 1;
        toggleRemoveLink();
      }
    });

    $(document).on('nested:fieldRemoved', function(e) {
      var check_remove_screen_tab = $(e.currentTarget.activeElement).hasClass('screen_tab_remove');
      if (check_remove_screen_tab ){
        tabCount -= 1;
        toggleRemoveLink();
      }
    });

    tabCount = $('.screen_tabs_present').length;
    toggleRemoveLink();
  });

});
