# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  let!(:user) do
    described_class.new(
      role: Role.find_or_create_by!(name: "Administrator"),
      gender: "male",
      email: "jd@gmail.com",
      password: "pass1234",
      first_name: "John",
      last_name: "Doe"
    )
  end

  it "does not save without email and password" do
    user = described_class.new(first_name: "John", last_name: "Doe")
    expect(user.save).to be false
  end

  it "does not save without first name and last name" do
    user = described_class.new(email: "jd@gmail.com", password: "pass123")
    expect(user.save).to be false
  end

  it "saves" do
    expect(user.save).to be true
  end

  it "updates password" do
    user.save
    user.update(password: "admin123")
    user.reload
    expect(user.password).to eq("admin123")
  end

  it "does not update new password similar to old" do
    user.save
    expect(user.update(password: "pass1234")).to be false
  end
end
