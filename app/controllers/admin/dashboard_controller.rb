# frozen_string_literal: true

module Admin
  class DashboardController < AdminController
    # GET /admin/dashboard
    def index # rubocop:disable Metrics/AbcSize
      @unfulfilled_orders = Order.recent_unfulfilled
      @quick_stats = {
        revenue: Order.revenue,
        sales: Order.sales,
        avg_sale: Order.avg_sale,
        per_sale: Order.per_sale
      }
      @orders_by_day = Order.where("created_at > ?", 7.days.ago).order(:created_at)
      @orders_by_day = @orders_by_day.group_by { |order| order.created_at.localtime.to_date }
      @revenue_by_day =
        @orders_by_day.map { |day, orders| [day.strftime("%A"), orders.sum(&:total)] }

      return unless @revenue_by_day.count < 7
      days_of_week = Date::DAYNAMES
      data_hash = @revenue_by_day.to_h
      current_day_index = Time.current.localtime.wday
      next_day_index = (current_day_index + 1) % days_of_week.length
      ordered_days_with_current_last =
        days_of_week[next_day_index..] + days_of_week[0...next_day_index]
      complete_ordered_array_with_current_last =
        ordered_days_with_current_last.map { |day| [day, data_hash.fetch(day, 0)] }
      @revenue_by_day = complete_ordered_array_with_current_last
    end
  end
end
