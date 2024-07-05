# frozen_string_literal: true

require "rails_helper"

RSpec.describe Subscriber do
  it "does not save without email" do
    subscriber = described_class.new
    expect(subscriber.save).to be false
  end

  it "saves" do
    subscriber = described_class.new(email: "jd@gmail.com")
    expect(subscriber.save).to be true
  end
end
