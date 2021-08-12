require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it do
      belong_to(:author)
        .class_name('User')
        .with_foreign_key('author_id')
    end
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:text) }
  end
end
