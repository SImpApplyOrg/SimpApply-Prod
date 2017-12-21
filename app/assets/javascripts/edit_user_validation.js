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

    $('#edit_user')
    .formValidation({
        framework: 'bootstrap',
        icon: {
            valid: 'fa fa-check',
            invalid: 'fa fa-question',
            validating: 'fa fa-refresh'
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
                        url: '/users/check_mobile_no',
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
                        message: 'Address is required'
                    }
                }
            },
            'user[password]': {
                validators: {
                    stringLength: {
                        min: 6,
                        message: 'Password is not valid'
                    }
                }
            },
            'user[password_confirmation]': {
                validators: {
                    identical: {
                        field: 'user[password]',
                        message: 'Password and its confirm are not same'
                    }
                }
            }
        }
    })

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
