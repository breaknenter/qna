class NewAnswerNotificationMailer < ApplicationMailer
  def notificate(subscriber, question, new_answer)
    @question = question
    @new_answer = new_answer

    mail to: subscriber.email, subject: 'QnA: new answer for question'
  end
end
