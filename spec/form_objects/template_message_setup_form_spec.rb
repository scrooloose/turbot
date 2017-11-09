require 'rails_helper'

RSpec.describe TemplateMessageSetupForm do
  let(:biking) { create(:interest, :biking) }
  let(:running) { create(:interest, :running) }
  let(:user) { create(:user) }
  let(:form) { described_class.new(user_id: user.id) }

  describe "#update" do
    it "updates for interest_ids" do
      form.update(interest_ids: [biking.id, running.id])

      expect(form.interests).to match_array([biking, running])
    end

    it "updates messages" do
      form.update(messages: {
        '0' => { 'interest_id' => biking.id, 'message' => 'Biking is awesome' },
        '1' => { 'interest_id' => running.id, 'message' => 'Running is awesome' },
      })

      #FIXME: this is a crappy way to check for success, but will have to do for now
      form.save
      user.reload
      expect(user.template_messages.find_by!(interest_id: running.id).content).to eq("Running is awesome")
      expect(user.template_messages.find_by!(interest_id: biking.id).content).to eq("Biking is awesome")

    end
  end

  describe "#save" do
    let(:messages_hash) do
      {
        messages: {
          '0' => { 'interest_id' => biking.id, 'message' => 'Biking is awesome' },
          '1' => { 'interest_id' => running.id, 'message' => 'Running is awesome' },
        }
      }
    end

    it "creates template messages for the user" do
      form.update(messages_hash).save

      user.reload
      expect(user.template_messages.find_by!(interest_id: running.id).content).to eq("Running is awesome")
      expect(user.template_messages.find_by!(interest_id: biking.id).content).to eq("Biking is awesome")
      expect(user.template_messages.count).to eq(2)
    end

    it "removes old template messages" do
      create(:template_message, user: user)

      form.update(messages_hash).save

      user.reload
      expect(user.template_messages.find_by!(interest_id: running.id).content).to eq("Running is awesome")
      expect(user.template_messages.find_by!(interest_id: biking.id).content).to eq("Biking is awesome")
      expect(user.template_messages.count).to eq(2)
    end

  end
end
