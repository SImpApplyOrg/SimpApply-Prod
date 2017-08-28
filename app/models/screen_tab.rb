class ScreenTab < ApplicationRecord
  has_many :tab_fields, dependent: :destroy
  accepts_nested_attributes_for :tab_fields, :allow_destroy => true,:reject_if     => :all_blank
  belongs_to :view_screen

  validates_presence_of :name, :position
  validates_uniqueness_of :position, scope: :view_screen_id

end
