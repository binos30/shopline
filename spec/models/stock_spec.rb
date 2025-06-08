# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stock do
  describe "db_columns" do
    it { should have_db_column(:product_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:size).of_type(:string).with_options(null: false) }
    it { should have_db_column(:quantity).of_type(:integer).with_options(null: false, default: 0) }
  end

  describe "db_indexes" do
    it { should have_db_index(%i[product_id size]).unique }
    it { should have_db_index(:product_id) }
  end

  describe "associations" do
    describe "belongs_to" do
      it { should belong_to(:product).inverse_of(:stocks) }
    end

    describe "has_many" do
      it { should have_many(:order_items).inverse_of(:stock).dependent(:restrict_with_exception) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:size) }
      it { should validate_presence_of(:quantity) }
    end

    describe "numericality" do
      it { should validate_numericality_of(:quantity).only_integer.is_in(0..999_999_999) }
    end

    describe "uniqueness" do
      subject { build(:stock) }

      it { should validate_uniqueness_of(:size).scoped_to(:product_id).case_insensitive }
    end
  end
end
