# frozen_string_literal: true

module Admin
  class SubscribersController < AdminController
    # GET /admin/subscribers
    def index
      @subscribers = Subscriber.filters(params.slice(:email)).order(:email)
      @pagy, @subscribers = pagy(@subscribers, items: count_per_page)
    end
  end
end
