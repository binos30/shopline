# frozen_string_literal: true

require "rails_helper"

RSpec.describe Subscriber, type: :model do
  describe "db_columns" do
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
    it { should have_db_column(:ip_address).of_type(:string).with_options(null: false, default: "") }
    it { should have_db_column(:user_agent).of_type(:string).with_options(null: false, default: "") }
  end

  describe "db_indexes" do
    it { should have_db_index(:email).unique }
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:email) }
    end

    describe "length" do
      it { should validate_length_of(:email).is_at_most(255) }
    end

    describe "uniqueness" do
      subject { build :subscriber }

      it { should validate_uniqueness_of(:email).case_insensitive }
    end

    describe "format" do
      subject { build :subscriber }

      it "email accepts a valid value" do
        subject.email = "subscriber@email.com"
        expect(subject).to be_valid
      end

      it "email does not accept an invalid format" do
        subject.email = "subscriber@"
        expect(subject).to be_invalid
      end
    end
  end
end
