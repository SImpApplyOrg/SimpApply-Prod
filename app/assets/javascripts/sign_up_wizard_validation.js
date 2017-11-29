$(document).on('turbolinks:load', function() {
    // You don't need to care about this function
    // It is for the specific demo
    function adjustIframeHeight() {
        var $body   = $('body'),
        $iframe = $body.data('iframe.fv');
        if ($iframe) {
            // Adjust the height of iframe
            $iframe.height($body.height());
        }
    }

    $('#installationForm')
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
            },
            'mobile_code': {
                validators: {
                    notEmpty: {
                        message: "Mobile code can't be blank"
                    },
                    remote: {
                        message: 'Mobile code is not valid',
                        url: '/users/check_verfication_code',
                        type: 'POST'
                    }
                }
            },
            'user[merchant_code]': {
                validators: {
                    notEmpty: {
                        message: "Merchant code can't be blank"
                    },
                    stringLength: {
                        min: 5,
                        max: 10
                    },
                    regexp: {
                        message: 'Merchant code must be alphanumeric',
                        regexp: /^[a-z0-9]+$/i
                    },
                    remote: {
                        message: "Merchant code already exist",
                        url: '/users/check_merchant_code',
                        type: 'POST'
                    }
                }
            },
            'user[email]': {
                validators: {
                    notEmpty: {
                        message: 'Email address is required'
                    },
                    emailAddress: {
                        message: 'Email address is not valid'
                    },
                    remote: {
                        message: "Email already exist",
                        url: '/users/check_email',
                        type: 'POST'
                    }
              }
            },
            'user[organization_name]': {
                validators: {
                    notEmpty: {
                        message: 'Business name is required'
                    },
                    regexp: {
                        message: 'Business name must be charctor only, special charctor not allow',
                        regexp: /^[a-zA-Z]+(?: [a-zA-Z]+)?$/
                    }
                }
            },
            'user[address]': {
                validators: {
                    notEmpty: {
                        message: 'address is required'
                    }
                }
            },
            'user[password]': {
                validators: {
                    notEmpty: {
                        message: 'Password is required'
                    },
                    stringLength: {
                        min: 6,
                        message: 'Password is not valid'
                    }
                }
            },
            'user[password_confirmation]': {
                validators: {
                    notEmpty: {
                        message: 'Confirm password is required'
                    },
                    identical: {
                        field: 'user[password]',
                        message: 'Password and its confirm are not same'
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

            return isValidTab;
        },
        // onPrevious: function(tab, navigation, index) {
        //     return validateTab(index + 1);
        // },
        onTabShow: function(tab, navigation, index) {
            var tabs = $('#installationForm').find('.tab-pane');
            var numTabs = tabs.length;

            sendVerificationCode(index, numTabs);

            if (index == (numTabs - 1)){
                $('.wizard li.finish').removeClass('hide');
                $('.wizard li.next').addClass('hide');
            }
        }
    });

    function validateTab(index) {
        var fv   = $('#installationForm').data('formValidation'), // FormValidation instance
        // The current tab
        $tab = $('#installationForm').find('.tab-pane').eq(index);

        // Validate the container
        fv.validateContainer($tab);

        var isValidStep = fv.isValidContainer($tab);
        if (isValidStep === false || isValidStep === null) {
            // Do not jump to the target tab
            return false;
        }

        return true;
    }

    function sendVerificationCode(index, numTabs) {
        if (numTabs < 4) {
          return;
        }

        if (index == 2) {
            $('.did_not_get_code').hide();
            var mobileNo = $('#user_mobile_no').val();

            $.post('/users/send_verification_code',
              { user: { mobile_no: mobileNo } }
            ).done(function(){
              setTimeout(function(){
                $('.did_not_get_code').show();
              }, 2000
            );
            });
        }
    }

    $("#user_mobile_no").on("countrychange", function(e, countryData) {
        $('#installationForm').formValidation('revalidateField', 'user[mobile_no]');
        // $("#user_mobile_no").val($(this).val());
    });


    $("#user_mobile_no").intlTelInput({
        autoHideDialCode: false,
        nationalMode: false,
        initialCountry: "US"
    });

});
