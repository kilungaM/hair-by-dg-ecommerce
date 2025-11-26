class CartController < ApplicationController
  before_action :initialize_cart
  before_action :find_product, only: [:add_to_cart]

  def add_to_cart
    cart = session[:cart]
    cart[@product.id.to_s] ||= 0
    cart[@product.id.to_s] += 1

    flash[:success] = "#{@product.name} added to cart!"
    redirect_to product_path(@product)
  end

  def update_cart
    product_id = params[:id]
    quantity = params[:quantity].to_i

    # Validate that the product exists in cart
    unless session[:cart].key?(product_id)
      flash[:error] = "Product not found in cart"
      redirect_to cart_path and return
    end

    # Validate quantity is at least 1
    if quantity < 1
      flash[:error] = "Quantity must be at least 1"
      redirect_to cart_path and return
    end

    # Update the quantity
    session[:cart][product_id] = quantity
    flash[:success] = "Cart updated successfully"
    redirect_to cart_path
  end

  def remove_from_cart
    product_id = params[:id]

    if session[:cart].delete(product_id)
      flash[:success] = "Item removed from cart"
    else
      flash[:error] = "Item not found in cart"
    end

    redirect_to cart_path
  end

  def view_cart
    breadcrumb "Home", root_path
    breadcrumb "Shopping Cart"

    @cart_items = []
    if session[:cart] && session[:cart].any?
      session[:cart].each do |product_id, quantity|
        begin
          product = Product.find(product_id)
          @cart_items << { product: product, quantity: quantity }
        rescue ActiveRecord::RecordNotFound
          # Remove invalid product from cart
          session[:cart].delete(product_id)
        end
      end
    end
  end

  # Optional: Add increment/decrement actions for better UX
  def increment
    product_id = params[:id]
    if session[:cart].key?(product_id)
      session[:cart][product_id] += 1
      flash[:success] = "Quantity increased"
    end
    redirect_to cart_path
  end

  def decrement
    product_id = params[:id]
    if session[:cart].key?(product_id)
      if session[:cart][product_id] > 1
        session[:cart][product_id] -= 1
        flash[:success] = "Quantity decreased"
      else
        flash[:error] = "Quantity cannot be less than 1. Use Remove to delete item."
      end
    end
    redirect_to cart_path
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end

  def find_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Product not found"
    redirect_to products_path
  end
end