# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :model do
  describe "db_columns" do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:active).of_type(:boolean).with_options(null: false, default: true) }
    it { should have_db_column(:slug).of_type(:string).with_options(null: false) }
  end

  describe "db_indexes" do
    it { should have_db_index(:active) }
    it { should have_db_index(:name).unique }
    it { should have_db_index(:slug).unique }
  end

  describe "associations" do
    describe "has_one" do
      it { should have_one_attached(:image) }
      it { should have_rich_text(:description) }
    end

    describe "has_many" do
      it { should have_many(:products).inverse_of(:category).dependent(:destroy) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:name) }
    end

    describe "uniqueness" do
      subject { build :category }

      it { should validate_uniqueness_of(:name).case_insensitive }
    end
  end
end
