# frozen_string_literal: true

module Admin
  class StocksController < AdminController
    before_action :set_product, only: %i[index show new edit create update]
    before_action :set_stock, only: %i[show edit update destroy]

    # GET /admin/products/1/stocks
    def index
      @stocks = @product.stocks
    end

    # GET /admin/products/1/stocks/1
    def show
    end

    # GET /admin/products/1/stocks/new
    def new
      @stock = @product.stocks.build
    end

    # GET /admin/products/1/stocks/1/edit
    def edit
    end

    # POST /admin/products/1/stocks
    def create
      @stock = @product.stocks.new(stock_params)

      respond_to do |format|
        if @stock.save
          format.html do
            redirect_to admin_product_stock_url(@product.id, @stock),
                        notice: t("record.create", record: Stock.name, name: @stock.size)
          end
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/products/1/stocks/1
    def update
      respond_to do |format|
        if @stock.update(stock_params)
          format.html do
            redirect_to admin_product_stock_url(@stock.product_id, @stock),
                        notice: t("record.update", record: Stock.name, name: @stock.size)
          end
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/products/1/stocks/1
    def destroy
      @stock.destroy!

      respond_to do |format|
        format.html do
          redirect_to admin_product_stocks_url,
                      notice: t("record.delete", record: Stock.name, name: @stock.size)
        end
      end
    end

    private

    def set_product
      @product = Product.find(params[:product_id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Product not found #{params[:product_id]}"
      redirect_back(fallback_location: admin_products_url)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Stock not found #{params[:id]}"
      redirect_back(fallback_location: admin_product_stocks_url)
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:size, :quantity).each_value { |value| value.try(:strip!) }
    end
  end
end
