class JobApplicationQuestion < ApplicationRecord
  has_many :tab_fields, dependent: :destroy

  # validates_uniqueness_of :type_form_question_no, :allow_blank => true, :allow_nil => true
  validates :type_form_question_no, format: { with: /\A\d+[A-Z]{0,1}\Z/, message: "must be an integer or an integer followed by a single captial letter" }, if: '!type_form_question_no.blank?'

  before_save :modify_question_no, if: '!type_form_question_no.blank?'

  scope :type_form_questions, -> { where("field_id IS NOT NULL") }
  scope :custom_questions, -> { where(is_custom_field: true) }
  scope :not_hidden_field, -> { where("field_type != 'hidden'") }
  scope :archive_questions, -> { where(archive: true) }

  def self.order_by_no
    all.map {|i| i.type_form_question_no.blank? ? "1" : i.type_form_question_no.gsub(/\d+/) {|s| "%08d" % s.to_i } }.zip(all).sort.map{|x,y| y}
  end

  def question_text
    question_title.blank? ? question : question_title
  end

  def modify_question_no
    self.type_form_question_no = self.type_form_question_no.delete(' ').upcase
  end

  def with_archive_text
    archive? ? "* #{question_text}" : question_text
  end

  def self.tab_field_questions
    where("(field_type != 'hidden' OR is_custom_field = true) AND archive = false").order_by_no + where("archive = true").order_by_no
  end
end
