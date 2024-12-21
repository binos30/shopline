# frozen_string_literal: true

require "rails_helper"

RSpec.describe Product, type: :model do
  describe "db_columns" do
    it { should have_db_column(:category_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it do
      should have_db_column(:price).of_type(:decimal).with_options(
               null: false,
               default: 0.0,
               precision: 12,
               scale: 2
             )
    end
    it { should have_db_column(:active).of_type(:boolean).with_options(null: false, default: true) }
    it { should have_db_column(:slug).of_type(:string).with_options(null: false) }
  end

  describe "db_indexes" do
    it { should have_db_index(:active) }
    it { should have_db_index(:category_id) }
    it { should have_db_index(:name).unique }
    it { should have_db_index(:slug).unique }
  end

  describe "associations" do
    describe "belongs_to" do
      it { should belong_to(:category).inverse_of(:products) }
    end

    describe "has_one" do
      it { should have_rich_text(:description) }
    end

    describe "has_many" do
      it { should have_many_attached(:images) }
      it { should have_many(:stocks).inverse_of(:product).dependent(:destroy) }
      it { should have_many(:order_items).inverse_of(:product).dependent(:restrict_with_exception) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:price) }
    end

    describe "numericality" do
      it { should validate_numericality_of(:price).is_in(0..999_999_999) }
    end

    describe "uniqueness" do
      subject { build :product }

      it { should validate_uniqueness_of(:name).case_insensitive }
    end
  end
end
