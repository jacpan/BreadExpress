class Ability
  include CanCan::Ability
  # include BreadExpressHelpers::Cart
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all
      
    elsif user.role? :customer
      
      # they can read their own profile
      can :show, Customer do |c|  
        c.user.id == user.id
      end
      # they can update their own profile
      can :update, Customer do |c|  
        c.user.id == user.id
      end

      can :cart, Order
      can :add_item, Order
      can :remove_item, Order
      can :clear_items_in_cart, Order

      can :read, Item

      can :read, Address do |this_address|  
        my_addresses = user.customer.addresses.map(&:id)
        my_addresses.include? this_address.id 
      end

      can :create, Address do |this_address|  
        my_addresses = user.customer.addresses.map(&:id)
        my_addresses.include? this_address.id 
      end

      can :create, Address do |this_address|  
        my_addresses = user.customer.addresses.map(&:id)
        my_addresses.include? this_address.id 
      end

      can :update, Address do |this_address|  
        my_addresses = user.customer.addresses.map(&:id)
        my_addresses.include? this_address.id 
      end

      can :create, Order do |this_order|  
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? this_order.id 
      end

      can :read, Order do |this_order|  
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? this_order.id 
      end

    elsif user.role? :shipper
      can :item_shipped, Order
      
    else
      # guests can only read domains covered (plus home pages)
      can :read, Item
      can :create, Customer
    end

  end
end