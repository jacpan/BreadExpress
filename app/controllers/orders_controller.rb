class OrdersController < ApplicationController
  include BreadExpressHelpers::Cart
  include BreadExpressHelpers::Shipping 

  before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy, :item_shipped]
  authorize_resource
  
  def index
    if logged_in? && !current_user.role?(:customer)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(5)
    else
      create_cart
      @pending_orders = current_user.customer.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(5)
    end 
  end

  def show
    @order_items = @order.order_items.to_a
    if current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    else
      @previous_orders = @order.customer.orders.chronological.to_a
    end
  end

  def new
    @order = Order.new
    @order_items = get_list_of_items_in_cart
    @shipping_cost = calculate_cart_shipping
    @item_total = calculate_cart_items_cost 
    @total_cost = calculate_cart_items_cost + calculate_cart_shipping
  end

  def create
    @order = Order.new(order_params)
    @order.expiration_month = @order.expiration_month.to_i
    @order.expiration_year = @order.expiration_year.to_i
    if @order.save
      save_each_item_in_cart(@order)
      @order.pay
      redirect_to @order, notice: "Thank you for ordering from Bread Express."
      destroy_cart
      create_cart
    else
      render action: 'new'
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: "Your order was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: "This order was removed from the system."
  end

  def add_item
    add_item_to_cart(params[:id].to_i)
    redirect_to cart_path
  end

  def remove_item
    remove_item_from_cart(params[:id].to_i)
    redirect_to cart_path
  end

  def cart
    @order_items = get_list_of_items_in_cart
    @shipping_cost = calculate_cart_shipping
    @item_total = calculate_cart_items_cost 
    @total_cost = calculate_cart_items_cost + calculate_cart_shipping
  end

  def clear_items_in_cart 
    clear_cart
    redirect_to cart_path
  end

  def item_shipped
    @order.order_items.each do |oi|
      oi.shipped_on = Date.today
      oi.save!
    end
    redirect_to shippers_path
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id, :date, :customer_id, :grand_total, :credit_card_number, :expiration_month, :expiration_year)
  end

end