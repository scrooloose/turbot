require 'rails_helper'

RSpec.describe InterestPreferenceProcessor do
  describe "#perform" do
    let(:user) { create(:user) }
    let(:cooking) { create(:interest, :cooking) }
    let(:running) { create(:interest, :running) }

    describe "existing messages" do
      it "makes 'live' the template messages that have content" do
        msg = create(
          :template_message,
          user: user, content: "foo", interest: cooking,
          state: TemplateMessage::STATE_PENDING_CONTENT
        )
        described_class.new(user: user, interest_ids: [cooking.id]).perform

        expect(msg.reload.state.to_sym).to eq(TemplateMessage::STATE_LIVE)
      end

      it "makes 'pending_content' the template messages that have no content" do
        msg = create(
          :template_message,
          user: user, content: nil, interest: cooking,
          state: TemplateMessage::STATE_PENDING_CONTENT
        )
        described_class.new(user: user, interest_ids: [cooking.id]).perform

        expect(msg.reload.state.to_sym).to eq(TemplateMessage::STATE_PENDING_CONTENT)
      end

      it "makes 'disabled' the template messages that aren't in the enabled list" do
        msg = create(
          :template_message,
          user: user, content: "foo", interest: running,
          state: TemplateMessage::STATE_PENDING_CONTENT
        )
        described_class.new(user: user, interest_ids: [cooking.id]).perform

        expect(msg.reload.state.to_sym).to eq(TemplateMessage::STATE_DISABLED)
      end
    end

    it "creates new messages for enabled interests" do
      described_class.new(user: user, interest_ids: [cooking.id]).perform
      expect(user.template_messages.map(&:interest)).to eq([cooking])
    end
  end
end
