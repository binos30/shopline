# frozen_string_literal: true

module Site
  class HomeController < SiteController
    def index
      @categories =
        Category.includes([:rich_text_description, { image_attachment: :blob }]).active.order(:name).take(5)
    end
  end
end
