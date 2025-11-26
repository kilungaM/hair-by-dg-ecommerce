class PagesController < ApplicationController
  def home
    @featured_products = Product.limit(6)
  end
end