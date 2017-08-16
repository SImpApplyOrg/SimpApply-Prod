# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.first_or_create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

DefaultSetting.first_or_create(default_max_application_limit_for_trail_merchant: DefaultSetting::DEFAULT_MAX_APPLICATION_LIMIT)

ResponseMessage.where(message_type: 'new_merchant').first_or_create(message: "Hi, To become a merchant open this url sign_up_link and fillup the from")

ResponseMessage.where(message_type: 'exist_merchant').first_or_create(message: "Hi, Fillup the application by accessing the url type_form_link")