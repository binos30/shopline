# frozen_string_literal: true

require "rails_helper"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/admin/products/1/stocks", type: :request do
  let!(:admin) { create :user, :as_admin }
  let!(:product) { create :product, :with_stocks }

  # This should return the minimal set of attributes required to create a valid
  # Stock. As you add validations to Stock, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { size: 10, quantity: 5, product_id: product.id } }

  let(:invalid_attributes) { { size: "" } }

  before { sign_in(admin) }

  describe "GET /index" do
    before { get admin_product_stocks_url(product) }

    it "renders a successful response" do
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    let(:stock) { product.stocks.first }

    before { get admin_product_stock_url(product, stock) }

    it "renders a successful response" do
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_admin_product_stock_url(product)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    let(:stock) { product.stocks.first }

    before { get edit_admin_product_stock_url(product, stock) }

    it "renders a successful response" do
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Stock" do
        expect do post admin_product_stocks_url(product), params: { stock: valid_attributes } end.to change(
          Stock,
          :count
        ).by(1)
      end

      it "redirects to the created stock" do
        post admin_product_stocks_url(product), params: { stock: valid_attributes }
        expect(response).to redirect_to(admin_product_stock_url(product, Stock.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Stock" do
        expect do post admin_product_stocks_url(product), params: { stock: invalid_attributes } end.not_to change(
          Stock,
          :count
        )
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post admin_product_stocks_url(product), params: { stock: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    let(:stock) { product.stocks.first }
    let(:new_attributes) { { quantity: 8 } }

    context "with valid parameters" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      it "updates the requested stock" do
        expect { patch admin_product_stock_url(product, stock), params: { stock: new_attributes } }.to(
          change { stock.reload.quantity }.to(8)
        )
      end

      it "redirects to the stock" do
        patch admin_product_stock_url(product, stock), params: { stock: new_attributes }
        stock.reload
        expect(response).to redirect_to(admin_product_stock_url(product, stock))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch admin_product_stock_url(product, stock), params: { stock: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    let(:stock) { product.stocks.first }

    it "destroys the requested stock" do
      expect { delete admin_product_stock_url(product, stock) }.to change(Stock, :count).by(-1)
    end

    it "redirects to the stocks list" do
      delete admin_product_stock_url(product, stock)
      expect(response).to redirect_to(admin_product_stocks_url)
    end
  end
end
