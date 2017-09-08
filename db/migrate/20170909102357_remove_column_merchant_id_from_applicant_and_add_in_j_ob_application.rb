class RemoveColumnMerchantIdFromApplicantAndAddInJObApplication < ActiveRecord::Migration[5.1]
  def change
    remove_column :applicants, :merchant_id, :integer
    add_column :job_applications, :merchant_id, :integer
  end
end
