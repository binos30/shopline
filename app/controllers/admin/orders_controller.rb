# frozen_string_literal: true

module Admin
  class OrdersController < AdminController
    before_action :set_order, only: :show

    # GET /admin/orders or /admin/orders.json
    def index
      count_per_page = ITEMS_PER_PAGE_ARRAY.find { |e| e == params[:count_per_page].to_i } || 10
      @orders = Order.filter(params.slice(:order_code)).order(created_at: :desc)
      @pagy, @orders = pagy(@orders, items: count_per_page)
    end

    # GET /admin/orders/1 or /admin/orders/1.json
    def show
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.includes(:order_items).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Order not found #{params[:id]}"
      redirect_back(fallback_location: admin_orders_url)
    end
  end
end
