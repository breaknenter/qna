class DailyDigestMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions

    mail to: user.email, subject: 'QnA daily digest'
  end
end
