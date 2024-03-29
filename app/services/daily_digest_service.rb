class DailyDigestService
  def send_digest
    questions = Question.per_day.to_a

    return if questions.empty?

    User.find_each(batch_size: 100) do |user|
      DailyDigestMailer.digest(user, questions).deliver_later
    end
  end
end
