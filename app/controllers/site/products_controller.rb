# frozen_string_literal: true

module Site
  class ProductsController < SiteController
    def index
      @products =
        Product
          .includes(images_attachments: :blob)
          .filters(params.slice(:name, :min, :max))
          .available
          .active
          .order(:name)
      @pagy, @products = pagy_countless(@products, items: 10)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def show
      @product =
        Product
          .includes([:stocks, { images_attachments: :blob }])
          .available
          .active
          .find(params[:slug])
    rescue ActiveRecord::RecordNotFound
      logger.error "Product not found #{params[:slug]}"
      redirect_back(fallback_location: root_url)
    end
  end
end
