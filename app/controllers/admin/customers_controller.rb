# frozen_string_literal: true

module Admin
  class CustomersController < AdminController
    # GET /admin/customers
    def index
      @customers = User.customers.filters(params.slice(:name))
      @pagy, @customers = pagy(@customers, items: count_per_page)
    end
  end
end
