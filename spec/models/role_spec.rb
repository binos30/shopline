# frozen_string_literal: true

require "rails_helper"

RSpec.describe Role, type: :model do
  describe "db_columns" do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:active).of_type(:boolean).with_options(null: false, default: true) }
  end

  describe "db_indexes" do
    it { should have_db_index(:active) }
    it { should have_db_index(:name).unique }
  end

  describe "associations" do
    describe "has_many" do
      it { should have_many(:users).inverse_of(:role).dependent(:restrict_with_exception) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:name) }
    end

    describe "length" do
      it { should validate_length_of(:name).is_at_least(2).is_at_most(40) }
    end

    describe "uniqueness" do
      subject { build :role }

      it { should validate_uniqueness_of(:name).case_insensitive }
    end

    describe "format" do
      subject { build :role }

      describe "name" do
        it "accepts a valid value" do
          subject.name = "role"
          expect(subject).to be_valid
        end

        it "does not accept an invalid format" do
          subject.name = "role-1"
          expect(subject).to be_invalid
        end
      end
    end
  end
end
