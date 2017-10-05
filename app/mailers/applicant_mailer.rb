class ApplicantMailer < ApplicationMailer

  default(
    from: "no-reply@simp-apply.com"
  )

  def send_resume(applicant_id)
    applicant = Applicant.find(applicant_id)

    recipient = applicant.get_question_value('8')
    recipient = recipient.blank? ? 'genesis@sparxo.com' : recipient.strip

    dir = Rails.root.join('public', 'resumes', applicant.id.to_s)

    unless File.exists?(dir+"resume.pdf")
      # To write changes to the file, use:
      dir = Rails.root.join('public', 'resumes', applicant.id.to_s)
      FileUtils.mkpath(dir) unless File.directory?(dir)
      File.open(dir+"resume.pdf", "wb") {|file| file << applicant.generate_cv }
    end

    attachments['resume.pdf'] = File.read(dir+"resume.pdf")
    mail(:to => recipient, :subject => "Applicant Resume", body: 'your resume is attached')
  end
end
