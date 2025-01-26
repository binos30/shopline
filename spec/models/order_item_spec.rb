# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderItem, type: :model do
  describe "db_columns" do
    it { should have_db_column(:order_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:product_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:stock_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:product_name).of_type(:string).with_options(null: false) }
    it do
      should have_db_column(:product_price).of_type(:decimal).with_options(
               null: false,
               default: 0.0,
               precision: 12,
               scale: 2
             )
    end
    it { should have_db_column(:size).of_type(:string).with_options(null: false) }
    it { should have_db_column(:quantity).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:subtotal).of_type(:decimal).with_options(null: false, precision: 12, scale: 2) }
  end

  describe "db_indexes" do
    it { should have_db_index(:order_id) }
    it { should have_db_index(:product_id) }
    it { should have_db_index(:stock_id) }
  end

  describe "associations" do
    describe "belongs_to" do
      it { should belong_to(:order).inverse_of(:order_items) }
      it { should belong_to(:product).inverse_of(:order_items) }
      it { should belong_to(:stock).inverse_of(:order_items) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:product_name) }
      it { should validate_presence_of(:size) }
      it { should validate_presence_of(:quantity) }
      it { should validate_presence_of(:product_price) }
    end

    describe "numericality" do
      it { should validate_numericality_of(:quantity).is_greater_than(0) }
      it { should validate_numericality_of(:product_price).is_greater_than_or_equal_to(0) }
    end
  end
end
