# frozen_string_literal: true

module Admin
  class ProductsController < AdminController
    before_action :set_lookups, only: %i[new create edit update]
    before_action :set_product, only: %i[show edit update destroy]

    # GET /admin/products or /admin/products.json
    def index
      @products = Product.includes([:category, { images_attachments: :blob }])
    end

    # GET /admin/products/1 or /admin/products/1.json
    def show
    end

    # GET /admin/products/new
    def new
      @product = Product.new
    end

    # GET /admin/products/1/edit
    def edit
    end

    # POST /admin/products or /admin/products.json
    def create # rubocop:disable Metrics/AbcSize
      @product = Product.new(product_params)

      respond_to do |format|
        if @product.save
          format.html do
            redirect_to admin_product_url(@product),
                        notice: t("record.create", record: Product.name, name: @product.name)
          end
          format.json { render :show, status: :created, location: admin_product_url(@product) }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    rescue ActiveRecord::RecordNotUnique => e
      @product.errors.add(:base, e)
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @product.errors, status: :unprocessable_entity }
    end

    # PATCH/PUT /admin/products/1 or /admin/products/1.json
    def update # rubocop:disable Metrics/AbcSize
      respond_to do |format|
        if @product.update(product_params.reject { |k| k["images"] })
          product_params["images"]&.each { |image| @product.images.attach(image) }
          format.html do
            redirect_to admin_product_url(@product),
                        notice: t("record.update", record: Product.name, name: @product.name)
          end
          format.json { render :show, status: :ok, location: admin_product_url(@product) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    rescue ActiveRecord::RecordNotUnique => e
      @product.errors.add(:base, e)
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @product.errors, status: :unprocessable_entity }
    end

    # DELETE /admin/products/1 or /admin/products/1.json
    def destroy
      @product.destroy!

      respond_to do |format|
        format.html do
          redirect_to admin_products_url,
                      notice: t("record.delete", record: Product.name, name: @product.name)
        end
        format.json { head :no_content }
      end
    end

    private

    def set_lookups
      @categories = Category.active.order(:name)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_product # rubocop:disable Metrics/AbcSize
      @product =
        if action_name == "show"
          Product.includes([:category, { images_attachments: :blob }]).find(params[:id])
        elsif action_name == "edit"
          Product.includes([{ images_attachments: :blob }]).find(params[:id])
        else
          Product.find(params[:id])
        end
    rescue ActiveRecord::RecordNotFound
      logger.error "Product not found #{params[:id]}"
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
