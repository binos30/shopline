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
      @pagy, @products = pagy_countless(@products, limit: 10)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def show
      @product =
        Product
          .includes([:stocks, { images_attachments: :blob }])
          .active
          .find_by_friendly_id(params[:slug]) # rubocop:disable Rails/DynamicFindBy
    rescue ActiveRecord::RecordNotFound
      logger.error "Product not found #{params[:slug]}"
      redirect_back(fallback_location: root_url)
    end
  end
end
