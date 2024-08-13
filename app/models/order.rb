# frozen_string_literal: true

class Order < ApplicationRecord
  include Filterable

  belongs_to :user

  has_many :order_items, -> { order(:id) }, dependent: :destroy, inverse_of: :order

  broadcasts_refreshes

  validates :customer_email, :customer_full_name, :customer_address, presence: true
  validate :validate_has_one_item

  after_initialize :generate_order_code, if: :new_record?

  scope :datatable,
        -> do
          select(
            "orders.id, orders.order_code, orders.created_at, orders.fulfilled, orders.total,
            CONCAT(users.first_name, ' ', users.last_name) AS customer_full_name"
          ).from("orders JOIN users ON orders.user_id = users.id").order(created_at: :desc)
        end
  scope :recent_unfulfilled, -> { where(fulfilled: false).order(created_at: :desc).take(5) }
  scope :today, -> { where(created_at: Time.current.midnight..Time.current) }
  scope :revenue, -> { today.sum(:total) }
  scope :sales, -> { today.count }
  scope :avg_sale, -> { today.average(:total).to_f }
  scope :per_sale, -> { joins(:order_items).today.average(:quantity).to_i }
  scope :filter_by_order_code, ->(order_code) { where("order_code ILIKE ?", "%#{order_code}%") }
  scope :filter_by_customer,
        ->(customer) { where("CONCAT(users.first_name, ' ', users.last_name) ILIKE ?", "%#{customer}%") }

  def fulfill!
    lock!

    if fulfilled
      errors.add(:order, "#{order_code} is already fulfilled.")
      raise ActiveRecord::RecordInvalid, self
    end
    update!(fulfilled: true)
  end

  private

  def generate_order_code
    epoch_time = Time.current.to_i

    self.order_code = "SL-#{epoch_time}-0#{rand(10)}"
  end

  def validate_has_one_item
    errors.add(:order, "needs at least one item") if order_items.empty?
  end
end
