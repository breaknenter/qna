require "rails_helper"

RSpec.describe NewAnswerNotificationMailer, type: :mailer do
  describe '#notificate' do
    let(:question) { create(:question) }
    let(:new_answer) { create(:answer, question: question, author: question.author) }
    let(:subscriber) { create(:user) }
    let!(:subscription) { create(:subscription, subscriber: subscriber, question: question) }
    let(:notification) { NewAnswerNotificationMailer.notificate(subscriber, question, new_answer) }

    it 'renders the headers' do
      expect(notification.subject).to eq('QnA: new answer for question')
      expect(notification.to).to eq([subscriber.email])
      expect(notification.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(notification.body.encoded).to match(question.title)
      expect(notification.body.encoded).to match(new_answer.text)
    end
  end
end
