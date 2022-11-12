require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'associations' do
    it { should belong_to(:subscriber).class_name('User').with_foreign_key('user_id') }
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of(:subscriber) }
    it { should validate_presence_of(:question) }
    it { should validate_uniqueness_of(:subscriber).scoped_to(:question) }
  end
end
