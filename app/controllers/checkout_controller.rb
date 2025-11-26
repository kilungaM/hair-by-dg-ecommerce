class CheckoutController < ApplicationController
  before_action :check_cart, only: [:new]

  def new
    breadcrumb "Home", root_path
    breadcrumb "Shopping Cart", cart_path
    breadcrumb "Checkout"

    @customer = Customer.new
    @provinces = Province.all
    @cart_items = get_cart_items
    @subtotal = calculate_subtotal(@cart_items)
  end

  def create
    @provinces = Province.all
    @cart_items = get_cart_items

    # Check if cart is empty
    if @cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty' and return
    end

    @customer = Customer.new(customer_params)

    if @customer.save
      # Create order
      province = @customer.province
      subtotal = calculate_subtotal(@cart_items)

      # Calculate taxes based on province
      gst = subtotal * (province.gst / 100.0)
      pst = subtotal * (province.pst / 100.0)
      hst = subtotal * (province.hst / 100.0)
      grand_total = subtotal + gst + pst + hst

      @order = @customer.orders.create!(
        status: 'pending',
        subtotal: subtotal,
        gst_amount: gst,
        pst_amount: pst,
        hst_amount: hst,
        grand_total: grand_total
      )

      # Create order items with prices at time of purchase
      @cart_items.each do |item|
        @order.order_items.create!(
          product_id: item[:product].id,
          quantity: item[:quantity],
          price: item[:product].price,
          name: item[:product].name
        )
      end

      # Clear cart
      session[:cart] = {}

      redirect_to order_confirmation_path(@order), notice: 'Order placed successfully!'
    else
      @subtotal = calculate_subtotal(@cart_items)
      flash.now[:error] = 'Please correct the errors below.'
      render :new
    end
  rescue => e
    Rails.logger.error "Checkout error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    redirect_to cart_path, alert: "Error processing order: #{e.message}"
  end

  def confirmation
    @order = Order.find(params[:id])
    @customer = @order.customer
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Order not found"
  end

  private

  def check_cart
    if session[:cart].blank? || session[:cart].empty?
      redirect_to cart_path, alert: 'Your cart is empty'
    end
  end

  def get_cart_items
    items = []
    return items if session[:cart].blank?

    session[:cart].each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      items << { product: product, quantity: quantity } if product
    end
    items
  end

  def calculate_subtotal(cart_items)
    cart_items.sum { |item| item[:product].price * item[:quantity] }
  end

  def customer_params
    params.require(:customer).permit(:email, :address, :city, :province_id)
  end
end