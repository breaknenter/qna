# Preview all emails at http://localhost:3000/rails/mailers/daily_digest
class DailyDigestPreview < ActionMailer::Preview
  def digest
    user = User.first
    questions = Question.first(2)

    DailyDigestMailer.digest(user, questions)
  end
end
