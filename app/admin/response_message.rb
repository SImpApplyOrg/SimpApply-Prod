ActiveAdmin.register ResponseMessage do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  config.filters = false

  form do |f|
    f.inputs do
      f.input :message_type, as: :select, collection: ResponseMessage::message_types.map(&:reverse), prompt: "Select Any"
      f.input :message
    end

    f.actions
  end

  permit_params :message, :message_type

end
