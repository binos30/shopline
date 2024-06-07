# frozen_string_literal: true

module Site
  class CategoriesController < SiteController
    def show
      @category = Category.includes(products: { images_attachments: :blob }).find(params[:slug])
      @products = @category.products
    rescue ActiveRecord::RecordNotFound
      logger.error "Category not found #{params[:slug]}"
      redirect_back(fallback_location: root_url)
    end
  end
end
