require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:daily_digest_service) { double('DailyDigestService') }

  before do
    allow(DailyDigestService).to receive(:new).and_return(daily_digest_service)
  end

  it 'calls DailyDigestService#send_digest' do
    expect(daily_digest_service).to receive(:send_digest)

    DailyDigestJob.perform_now
  end
end
