# frozen_string_literal: true

require "rails_helper"

# Specs in this file have access to a helper object that includes the TurboStreamActionsHelper.
RSpec.describe TurboStreamActionsHelper do
  describe "#redirect" do
    it "returns a turbo-stream tag" do
      expect(helper.redirect("/login")).to eq(
        "<turbo-stream url=\"/login\" action=\"redirect\"><template></template></turbo-stream>"
      )
    end
  end
end
