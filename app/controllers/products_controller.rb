class ProductsController < ApplicationController
  def index
    @products = Product.all.page(params[:page]).per(12)

    # Filter by category
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?

    # Filter by on_sale, new, or recently_updated
    @products = @products.on_sale if params[:filter] == 'on_sale'
    @products = @products.recent if params[:filter] == 'new'
    @products = @products.recently_updated if params[:filter] == 'recently_updated'

    # Search
    if params[:keyword].present?
      @products = @products.search_by_keyword_and_category(params[:keyword], params[:category_id])
    end

    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
  end
end