# frozen_string_literal: true

module Admin
  class ProductsController < AdminController
    before_action :set_lookups, only: %i[new create edit update]
    before_action :set_product, only: %i[update destroy]

    # GET /admin/products or /admin/products.json
    def index
      @products =
        Product.filters(params.slice(:name)).includes([:category, { images_attachments: :blob }]).order(:name)
      @pagy, @products = pagy(@products, limit: count_per_page)
    end

    # GET /admin/products/1 or /admin/products/1.json
    def show
      @product =
        Product.includes([:rich_text_description, { images_attachments: :blob }]).find_by_friendly_id(
          params[:slug]
        )
    end

    # GET /admin/products/new
    def new
      @product = Product.new
    end

    # GET /admin/products/1/edit
    def edit
      @product =
        Product.includes([:rich_text_description, { images_attachments: :blob }]).find_by_friendly_id(
          params[:slug]
        )
    end

    # POST /admin/products or /admin/products.json
    def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      @product = Product.new(product_params)

      respond_to do |format|
        if @product.save
          format.html do
            redirect_to admin_product_url(@product),
                        notice: t("record.create", resource_name: t("resources.product"), name: @product.name)
          end
          format.json { render :show, status: :created, location: admin_product_url(@product) }
        else
          format.html { render :new, status: :unprocessable_content }
          format.json { render json: @product.errors, status: :unprocessable_content }
        end
      end
    rescue ActiveRecord::RecordNotUnique => e
      @product.errors.add(:base, e)
      respond_to do |format|
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @product.errors, status: :unprocessable_content }
      end
    end

    # PATCH/PUT /admin/products/1 or /admin/products/1.json
    def update # rubocop:disable Metrics/AbcSize
      respond_to do |format|
        if @product.update(product_params)
          format.html do
            redirect_to admin_product_url(@product),
                        notice: t("record.update", resource_name: t("resources.product"), name: @product.name)
          end
          format.json { render :show, status: :ok, location: admin_product_url(@product) }
        else
          format.html { render :edit, status: :unprocessable_content }
          format.json { render json: @product.errors, status: :unprocessable_content }
        end
      end
    rescue ActiveRecord::RecordNotUnique => e
      @product.errors.add(:base, e)
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @product.errors, status: :unprocessable_content }
      end
    end

    # DELETE /admin/products/1 or /admin/products/1.json
    def destroy # rubocop:disable Metrics/AbcSize
      @product.destroy!

      respond_to do |format|
        format.html do
          redirect_to admin_products_url,
                      notice: t("record.delete", resource_name: t("resources.product"), name: @product.name)
        end
        format.json { head :no_content }
      end
    rescue ActiveRecord::DeleteRestrictionError, ActiveRecord::InvalidForeignKey => e
      logger.tagged("Delete Product##{@product.id} Error") { logger.error e }
      redirect_to admin_products_url, alert: e
    end

    private

    def set_lookups
      @categories = Category.active.order(:name)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find_by_friendly_id(params[:slug])
    rescue ActiveRecord::RecordNotFound
      logger.error "Product not found #{params[:slug]}"
      redirect_back(fallback_location: admin_products_url)
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params
        .require(:product)
        .permit(:name, :description, :price, :active, :category_id, images: [])
        .each_value { |value| value.try(:strip!) }
    end
  end
end
