# frozen_string_literal: true

module Site
  class HomeController < SiteController
    def index
      @categories = Category.includes([:image_attachment]).active.order(:name).take(5)
    end
  end
end
