# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.first_or_create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

DefaultSetting.first_or_create(default_max_application_limit_for_trail_merchant: DefaultSetting::DEFAULT_MAX_APPLICATION_LIMIT)

ResponseMessage.where(message_type: 'new_merchant').first_or_create(message: "Hi, To become a merchant open this url {{sign_up_link}} and fillup the from")

ResponseMessage.where(message_type: 'exist_merchant').first_or_create(message: "Hi, Fillup the application by accessing the url {{type_form_link}}")

ResponseMessage.where(message_type: 'error_in_merchant_id').first_or_create(message: "Hi, Please send the message in proper format. Merchant ID should be alphanumeric, min-length-5, max-length-10.")

ResponseMessage.where(message_type: 'blank_merchant_id').first_or_create(message: "Hi, You have send a blank message. Please send the message in proper format. Merchant ID should be alphanumeric, min-length-5, max-length-10.")

ResponseMessage.where(message_type: 'new_application_form').first_or_create(message: "Hi, You have got a new application form")

ResponseMessage.where(message_type: 'view_application_form').first_or_create(message: "Hi, Merchant has reviewd your application form")

ResponseMessage.where(message_type: 'applicant_exist').first_or_create(message: "Hi, we’ve submitted your application for you and will notify when the hiring manager has received it")

ResponseMessage.where(message_type: 'error_in_email').first_or_create(message: "Hi Please send the message in proper format")

ResponseMessage.where(message_type: 'error_in_submit_applicant').first_or_create(message: "Hi, we got your application but there was some error to submit to hiring manager, Please contact to administrator.")

ResponseMessage.where(message_type: 'invite_manager').first_or_create(message: "Hi, {{merchant_first_name}} has invited you to thier organization {{organization_name}} as a Manager, you can accept it via clicking on this link. {{invitation_accept_link}}. Or if you have already have credentials login with them and accept the invitation. If you don't want to accept the invitation, please ignore this email or click on Reject button from your dashboard page. Your account won't be created until you access the link above and set your password.")

ResponseMessage.where(message_type: 'invite_reviewer').first_or_create(message: "Hi, {{merchant_first_name}} has invited you to thier organization {{organization_name}} as a Reviewer, you can accept it via clicking on this link. {{invitation_accept_link}}. Or if you have already have credentials login with them and accept the invitation. If you don't want to accept the invitation, please ignore this email or click on Reject button from your dashboard page. Your account won't be created until you access the link above and set your password.")

ResponseMessage.where(message_type: 'mobile_verification_code_message').first_or_create(message: "Hi, Here is your verification code: {{mobile_verification_code}}")

ResponseMessage.where(message_type: 'temp_password_reset').first_or_create(message: "Hi, Here is your temporary password is: {{temp_password}}")

JobApplicationQuestion.where(is_custom_field: true, question: "No of job applications").first_or_create(question_title: 'Total no of job applications for this applicant')

MessageTag.where(tag_name: 'sign_up_link').first_or_create(is_editable: false)
MessageTag.where(tag_name: 'type_form_link').first_or_create(is_editable: false)
MessageTag.where(tag_name: 'job_application_link').first_or_create(is_editable: false)
MessageTag.where(tag_name: 'merchant_first_name').first_or_create(is_editable: false)
MessageTag.where(tag_name: 'invitation_accept_link').first_or_create(is_editable: false)
MessageTag.where(tag_name: 'organization_name').first_or_create(is_editable: false)
MessageTag.where(tag_name: 'mobile_verification_code').first_or_create(is_editable: false)
MessageTag.where(tag_name: 'temp_password').first_or_create(is_editable: false)
