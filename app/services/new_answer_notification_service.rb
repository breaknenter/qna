class NewAnswerNotificationService
  def notificate(new_answer)
    subscribers = new_answer.question.subscribers.where.not(id: new_answer.author)
    question = new_answer.question

    subscribers.find_each(batch_size: 100) do |subscriber|
      NewAnswerNotificationMailer.notificate(subscriber, question, new_answer).deliver_later
    end
  end
end
