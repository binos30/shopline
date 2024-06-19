# frozen_string_literal: true

module Site
  class CategoriesController < SiteController
    def show
      @category = Category.active.find(params[:slug])
      @products =
        @category
          .products
          .filters(params.slice(:name, :min, :max))
          .includes(images_attachments: :blob)
          .active
    rescue ActiveRecord::RecordNotFound
      logger.error "Category not found #{params[:slug]}"
      redirect_back(fallback_location: root_url)
    end
  end
end
