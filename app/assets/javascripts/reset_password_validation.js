$(document).on('turbolinks:load', function() {
   $('#reset_password')
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
            'user[password]': {
                validators: {
                    notEmpty: {
                        message: 'Password is required'
                    },
                    stringLength: {
                        min: 5,
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
});