require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe '#digest' do
    let(:user) { build(:user) }
    let(:questions) { create_pair(:question) }
    let(:mail) { DailyDigestMailer.digest(user, questions) }

    it 'renders the headers' do
      expect(mail.subject).to eq('QnA daily digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('QnA daily digest')
    end

    it 'renders questions titles' do
      questions.each do |question|
        expect(mail.body.encoded).to have_content question.title
      end
    end
  end
end
