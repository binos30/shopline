# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user

  has_many :order_items, -> { order(:id) }, dependent: :destroy, inverse_of: :order

  validates :customer_email, :customer_full_name, :customer_address, presence: true
  validate :validate_has_one_item

  after_initialize :generate_order_code, if: :new_record?

  scope :recent_unfulfilled, -> { where(fulfilled: false).order(created_at: :desc).take(5) }
  scope :today, -> { where(created_at: Time.current.midnight..Time.current) }
  scope :revenue, -> { today.sum(:total) }
  scope :sales, -> { today.count }
  scope :avg_sale, -> { today.average(:total).to_f }
  scope :per_sale, -> { joins(:order_items).today.average(:quantity).to_i }

  private

  def generate_order_code
    current_time = Time.now.getlocal
    current_year = current_time.year.to_s
    current_month = current_time.strftime("%m")
    epoch_time = current_time.to_i.to_s.last(6)

    self.order_code = "SL-#{current_year}-#{current_month}-#{epoch_time}"
  end

  def validate_has_one_item
    errors.add(:order, "needs at least one item") if order_items.empty?
  end
end
