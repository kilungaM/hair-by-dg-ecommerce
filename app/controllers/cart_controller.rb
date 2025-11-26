class CartController < ApplicationController
  def add_to_cart
    product = Product.find(params[:id])
    cart = session[:cart] ||= {}
    cart[product.id.to_s] ||= 0
    cart[product.id.to_s] += 1

    flash[:success] = "#{product.name} added to cart!"
    redirect_to product_path(product)
  end

  def view_cart
    @cart_items = []
    if session[:cart]
      session[:cart].each do |product_id, quantity|
        product = Product.find(product_id)
        @cart_items << { product: product, quantity: quantity }
      end
    end
  end
end