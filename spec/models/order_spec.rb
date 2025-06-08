# frozen_string_literal: true

require "rails_helper"

RSpec.describe Order do
  describe "db_columns" do
    it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:customer_email).of_type(:string).with_options(null: false) }
    it { should have_db_column(:customer_full_name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:customer_address).of_type(:string).with_options(null: false) }
    it { should have_db_column(:fulfilled).of_type(:boolean).with_options(null: false, default: false) }
    it { should have_db_column(:order_code).of_type(:string).with_options(null: false) }

    it do
      expect(subject).to have_db_column(:total).of_type(:decimal).with_options(
        null: false,
        default: 0.0,
        precision: 12,
        scale: 2
      )
    end
  end

  describe "db_indexes" do
    it { should have_db_index(:customer_email) }
    it { should have_db_index(:customer_full_name) }
    it { should have_db_index(:fulfilled) }
    it { should have_db_index(:order_code).unique }
    it { should have_db_index(:user_id) }
  end

  describe "associations" do
    describe "belongs_to" do
      it { should belong_to(:user).inverse_of(:orders) }
    end

    describe "has_many" do
      it { should have_many(:order_items).inverse_of(:order).dependent(:destroy) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:order_code) }
      it { should validate_presence_of(:customer_email) }
      it { should validate_presence_of(:customer_full_name) }
      it { should validate_presence_of(:customer_address) }
    end

    describe "uniqueness" do
      subject { build(:order) }

      it { should validate_uniqueness_of(:order_code).case_insensitive }
    end
  end
end
