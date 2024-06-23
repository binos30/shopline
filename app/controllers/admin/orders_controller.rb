# frozen_string_literal: true

module Admin
  class OrdersController < AdminController
    before_action :set_order, only: %i[show fulfill]

    # GET /admin/orders or /admin/orders.json
    def index
      @orders = Order.filters(params.slice(:order_code, :customer)).order(created_at: :desc)
      @pagy, @orders = pagy(@orders, items: count_per_page)
    end

    # GET /admin/orders/1 or /admin/orders/1.json
    def show
    end

    def fulfill
      @order.fulfill!
      redirect_to admin_order_url(@order), notice: t("record.fulfill", code: @order.order_code)
    rescue ActiveRecord::RecordInvalid => e
      logger.tagged("Fulfill Order Error") { logger.error e.message }
      flash.now[:alert] = e.message
      render :show, status: :unprocessable_entity
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
