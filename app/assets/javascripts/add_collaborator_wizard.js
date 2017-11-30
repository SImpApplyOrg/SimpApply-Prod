var countryCode = "+1";

$(document).on('turbolinks:load', function() {

  $('#addCollaboratorForm')
    .formValidation({
      framework: 'bootstrap',
      icon: {
        valid: 'glyphicon glyphicon-ok',
        invalid: 'glyphicon glyphicon-remove',
        validating: 'glyphicon glyphicon-refresh'
      },
      // This option will not ignore invisible fields which belong to inactive panels
      excluded: ':disabled',
      fields: {
        'user[mobile_no]': {
          validators: {
            notEmpty: {
              message: "Mobile no can't be blank"
            },
            remote: {
              message: 'Mobile no is not valid',
              url: '/users/check_mobile_no',
              type: 'POST'
            }
          }
        }
      }
    })
    .bootstrapWizard({
        tabClass: 'nav nav-pills',
        // onTabClick: function(tab, navigation, index) {
        //     return validateTab(index);
        // },
        onNext: function(tab, navigation, index) {
          var isValidTab = validateTab(index - 1);
          if (!isValidTab) {
            return false;
          }

          sendInvitation(index);

          return true;
        },
        onPrevious: function(tab, navigation, index) {
          $('#user_mobile_no').val(countryCode);
          $('#addCollaboratorForm').formValidation('revalidateField', 'user[mobile_no]');
          
          return true;
        },
        onTabShow: function(tab, navigation, index) {
          if (index == 0){
            $('.wizard li.previous').addClass('hide');
            $('.wizard li.next').removeClass('hide');
          } else if (index = 1) {
            $('.wizard li.next').addClass('hide');
            $('.wizard li.previous').removeClass('hide');
          }

          return true;
        }
    });

  function validateTab(index) {
    var fv   = $('#addCollaboratorForm').data('formValidation'), // FormValidation instance
      // The current tab
      $tab = $('#addCollaboratorForm').find('.tab-pane').eq(index);

    // Validate the container
    fv.validateContainer($tab);

    var isValidStep = fv.isValidContainer($tab);
    if (isValidStep === false || isValidStep === null) {
      // Do not jump to the target tab
      return false;
    }

    return true;
  }

  function sendInvitation(index) {
    var data = $('#addCollaboratorForm').serialize();
    $.post('/users/invitation', data)
      .fail(function() {
        window.location.reload();
      });
  }

  $("#user_mobile_no").on("countrychange", function(e, countryData) {
    $('#addCollaboratorForm').formValidation('revalidateField', 'user[mobile_no]');
    countryCode = "+" + countryData.dialCode;
    // $("#user_mobile_no").val($(this).val());
  });


  $("#user_mobile_no").intlTelInput({
    autoHideDialCode: false,
    nationalMode: false,
    initialCountry: "US"
  });
});
