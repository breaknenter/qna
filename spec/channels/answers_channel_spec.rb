require "rails_helper"

RSpec.describe AnswersChannel, type: :channel do
  it "successfully subscribes" do
    subscribe question_id: 1

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("question_1/answers")
  end
end
