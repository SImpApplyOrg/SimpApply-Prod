class Applicant < ApplicationRecord

  before_create :assign_reminder_date

  has_many :job_applications, dependent: :destroy
  has_many :merchants, through: :job_applications

  scope :have_details, -> { where("full_response IS NOT NULL")}

  def self.send_reminder_messages
    where("full_response IS NULL").each do |applicant|
      ReminderMessage.applicant.each do |reminder_message|
        reminder_date = applicant.get_reminder_date(reminder_message)

        SetupJobApplicationReminderJob.perform_now(applicant.id, reminder_message.id) if reminder_date.to_date == Date.today
      end
    end
  end

  def get_reminder_date(reminder_message)
    (reminder_message.since_signup_date? ? self.created_at : self.last_reminder_at) + reminder_message.remind_after.days
  end

  def have_details?
    !full_response.blank?
  end

  def generate_token_and_create_job_application(merchant)
    self.token = SecureRandom.base58(24)
    self.save
    create_job_application(merchant)
  end

  def create_job_application(merchant)
    job_applications.create(merchant_id: merchant.id)
  end

  def get_message_tag_value(type_form_question_id)
    tag_value = ""
    if question_answers.present?
      JSON.parse(question_answers).each do |question_answer|
        if question_answer["question_id"] == type_form_question_id
          tag_value = question_answer["admin_answer"].present? ? question_answer["admin_answer"] : question_answer["answer"]
          break
        end
      end
    end
    tag_value
  end

  def generate_cv
    resume_data = ApplicationController.render(template: "applicants/resume", layout: nil, assigns: { applicant: self })

    # To merely print the contents of the file, use:
    # WickedPdf.new.pdf_from_string(resume_data)
    HyPDF.htmltopdf(
      resume_data,
      orientation: 'Landscape'
    )
  end

  def get_question_value(question_no)
    job_application_question = JobApplicationQuestion.where(type_form_question_no: question_no).last
    (job_application_question ? get_message_tag_value(job_application_question.field_id.to_s) : "")
  end

  def first_name
    self.get_question_value('1')
  end

  def last_name
    self.get_question_value('2')
  end

  private

    def assign_reminder_date
      self.last_reminder_at = Time.now
    end
end
