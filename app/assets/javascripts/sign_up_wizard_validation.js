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
                            message: 'Merchant code must be alphanumeric'
                            regexp: /^[a-z0-9]+$/i
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
                            message: 'Organization name is required'
                        },
                        regexp: {
                            message: 'Organization name must be charctor only, special charctor not allow',
                            regexp: /^[a-zA-Z]+(?: [a-zA-Z]+)?$/
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
                var numTabs    = $('#installationForm').find('.tab-pane').length,
                    isValidTab = validateTab(index - 1);
                if (!isValidTab) {
                    return false;
                }

                return true;
            },
            // onPrevious: function(tab, navigation, index) {
            //     return validateTab(index + 1);
            // },
            onTabShow: function(tab, navigation, index) {
                // if (index == 1) {
                //     $('.did_not_get_code').hide();

                //     $.post('/users/send_verification_code', { user: { mobile_no: $('#user_mobile_no').val() } }).done(function(){
                //         setTimeout(function(){
                //             $('.did_not_get_code').show();
                //         }, 2000);
                //     });
                // }
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
});
