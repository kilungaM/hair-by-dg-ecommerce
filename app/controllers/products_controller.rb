class ProductsController < ApplicationController
  def index
    breadcrumb "Home", root_path
    breadcrumb "Products"

    @products = Product.all.page(params[:page]).per(12)

    # Filter by category
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
      category = Category.find(params[:category_id])
      breadcrumb category.name
    end

    # Filter by on_sale, new, or recently_updated
    @products = @products.on_sale if params[:filter] == 'on_sale'
    @products = @products.recent if params[:filter] == 'new'
    @products = @products.recently_updated if params[:filter] == 'recently_updated'

    # Search
    if params[:keyword].present?
      @products = @products.search_by_keyword_and_category(params[:keyword], params[:category_id])
      flash.now[:notice] = "Found #{@products.count} products matching '#{params[:keyword]}'"
    end

    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])

    breadcrumb "Home", root_path
    breadcrumb "Products", products_path
    breadcrumb @product.category.name, products_path(category_id: @product.category_id)
    breadcrumb @product.name
  end
end