# frozen_string_literal: true

module Site
  class CategoriesController < SiteController
    def show # rubocop:disable Metrics/AbcSize
      @category = Category.active.find(params[:slug])
      @products =
        @category
          .products
          .filters(params.slice(:name, :min, :max))
          .includes(images_attachments: :blob)
          .available
          .active
          .order(:name)
    rescue ActiveRecord::RecordNotFound
      logger.error "Category not found #{params[:slug]}"
      redirect_back(fallback_location: root_url)
    end
  end
end
