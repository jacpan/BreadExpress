class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
    if logged_in? && current_user.role?(:baker)
      redirect_to bakers_path
    elsif logged_in? && current_user.role?(:shipper)
      redirect_to shippers_path
    elsif logged_in? && current_user.role?(:admin)
      redirect_to dashboard_path
    elsif logged_in? && current_user.role?(:customer)
      redirect_to dashboard_path
    end

  end

  def about
  end

  def privacy
  end

  def contact
  end

  def dashboard
  end

  def bakers
    @muffins = create_baking_list_for("muffins")
    @bread = create_baking_list_for("bread")
    @pastries = create_baking_list_for("pastries")
  end

  def shippers
    @unshipped_items = Order.not_shipped
  end


end