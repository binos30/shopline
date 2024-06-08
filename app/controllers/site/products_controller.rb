# frozen_string_literal: true

module Site
  class ProductsController < SiteController
    def show
      @product =
        Product.includes([:stocks, { images_attachments: :blob }]).active.find(params[:slug])
    rescue ActiveRecord::RecordNotFound
      logger.error "Product not found #{params[:slug]}"
      redirect_back(fallback_location: root_url)
    end
  end
end
