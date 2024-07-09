# frozen_string_literal: true

module Site
  class OrdersController < SiteController
    before_action :check_and_authenticate_user

    def index
      @orders = current_user.orders.datatable.filters(params.slice(:order_code))
      @pagy, @orders = pagy(@orders, items: count_per_page)
    end

    def show
      @order = current_user.orders.includes(order_items: :product).find_by!(order_code: params[:order_code])
    rescue ActiveRecord::RecordNotFound
      logger.error "Order not found #{params[:order_code]}"
      redirect_back(fallback_location: orders_url)
    end

    private

    def check_and_authenticate_user
      redirect_to new_user_session_url unless user_signed_in?
      redirect_to root_url if user_signed_in? && !current_user.customer?
    end
  end
end
