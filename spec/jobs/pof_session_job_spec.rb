require 'rails_helper'

RSpec.describe PofSessionJob, type: :job do

  #could test this more exhaustively, but the important thing is that that
  #'run' message is sent
  describe "perform" do
    it "runs a PofSession" do
      u = create(:user)

      pof_session_double = double("PofSession")
      expect(pof_session_double).to receive(:run)
      expect(PofSession).to receive(:new).and_return(pof_session_double)

      described_class.new.perform(user_id: u.id)
    end
  end
end
