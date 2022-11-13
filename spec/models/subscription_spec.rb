require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'associations' do
    it { should belong_to(:subscriber).class_name('User').with_foreign_key('subscriber_id') }
    it { should belong_to(:question) }
  end

  describe 'validations' do
    subject { create(:subscription) }

    let(:resubscribe) do
      build(:subscription, subscriber: subject.subscriber, question: subject.question)
    end

    it { should validate_presence_of(:subscriber) }
    it { should validate_presence_of(:question) }

    # Не работает из-за бага:
    # it { should validate_uniqueness_of(:subscriber).scoped_to(:question) }

    it 'validates :subscriber, uniqueness: { scope: :question }' do
      resubscribe.valid?

      expect(resubscribe.errors[:subscriber]).to include('has already been taken')
    end
  end
end
