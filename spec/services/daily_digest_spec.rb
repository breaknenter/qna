require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_pair(:user) }
  let(:questions) { create_pair(:question, created_at: 1.day.ago, author: users.first).to_a }

  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions).and_call_original }

    subject.send_digest
  end
end
