# frozen_string_literal: true

module Admin
  class CategoriesController < AdminController
    before_action :set_category, only: %i[show edit update destroy]

    # GET /admin/categories or /admin/categories.json
    def index
      @categories = Category.filters(params.slice(:name)).includes(image_attachment: :blob).order(:name)
      @pagy, @categories = pagy(@categories, limit: count_per_page)
    end

    # GET /admin/categories/1 or /admin/categories/1.json
    def show
    end

    # GET /admin/categories/new
    def new
      @category = Category.new
    end

    # GET /admin/categories/1/edit
    def edit
    end

    # POST /admin/categories or /admin/categories.json
    def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      @category = Category.new(category_params)

      respond_to do |format|
        if @category.save
          format.html do
            redirect_to admin_category_url(@category),
                        notice: t("record.create", record: Category.name, name: @category.name)
          end
          format.json { render :show, status: :created, location: admin_category_url(@category) }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    rescue ActiveRecord::RecordNotUnique => e
      @category.errors.add(:base, e)
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end

    # PATCH/PUT /admin/categories/1 or /admin/categories/1.json
    def update # rubocop:disable Metrics/AbcSize
      respond_to do |format|
        if @category.update(category_params)
          format.html do
            redirect_to admin_category_url(@category),
                        notice: t("record.update", record: Category.name, name: @category.name)
          end
          format.json { render :show, status: :ok, location: admin_category_url(@category) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    rescue ActiveRecord::RecordNotUnique => e
      @category.errors.add(:base, e)
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end

    # DELETE /admin/categories/1 or /admin/categories/1.json
    def destroy # rubocop:disable Metrics/AbcSize
      @category.destroy!

      respond_to do |format|
        format.html do
          redirect_to admin_categories_url, notice: t("record.delete", record: Category.name, name: @category.name)
        end
        format.json { head :no_content }
      end
    rescue ActiveRecord::DeleteRestrictionError, ActiveRecord::InvalidForeignKey => e
      logger.tagged("Delete Category##{@category.id} Error") { logger.error e }
      redirect_to admin_categories_url, alert: e
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find_by_friendly_id(params[:slug]) # rubocop:disable Rails/DynamicFindBy
    rescue ActiveRecord::RecordNotFound
      logger.error "Category not found #{params[:slug]}"
      redirect_back(fallback_location: admin_categories_url)
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params
        .require(:category)
        .permit(:name, :description, :active, :image)
        .each_value { |value| value.try(:strip!) }
    end
  end
end
