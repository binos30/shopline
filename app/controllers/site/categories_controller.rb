# frozen_string_literal: true

module Site
  class CategoriesController < SiteController
    def index
      @categories = Category.includes(image_attachment: :blob).filters(params.slice(:name)).active.order(:name)
      @pagy, @categories = pagy_countless(@categories, items: 10)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def show # rubocop:disable Metrics/AbcSize
      @category = Category.active.find_by_friendly_id(params[:slug]) # rubocop:disable Rails/DynamicFindBy
      @products =
        @category
          .products
          .filters(params.slice(:name, :min, :max))
          .includes(images_attachments: :blob)
          .available
          .active
          .order(:name)
      @pagy, @products = pagy_countless(@products, items: 10)

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    rescue ActiveRecord::RecordNotFound
      logger.error "Category not found #{params[:slug]}"
      redirect_back(fallback_location: root_url)
    end
  end
end
