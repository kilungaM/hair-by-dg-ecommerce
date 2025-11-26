class PagesController < ApplicationController
  def home
    @featured_products = Product.limit(6)
  end

  def about
    @page = PageContent.find_by(slug: 'about')
  end

  def contact
    @page = PageContent.find_by(slug: 'contact')
  end
end