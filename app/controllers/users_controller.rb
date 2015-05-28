class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    @users = User.alphabetical.paginate(:page => params[:page]).per_page(7)
  end

  def show
  end

  def new
    @user = User.new
    @user.customer = Customer.new
    @user.active = true
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    unless current_user && current_user.role?(:admin)
      @user.role = :customer
    end
    if @user.save
      session[:user_id] = @user.id unless current_user.role?(:admin)
      if !current_user.role?(:admin)
        redirect_to home_path, notice: "Thank you for signing up!"
      else
        redirect_to employees_path, notice: "Your user has been created"
      end 
    else
      flash[:error] = "This user could not be created."
      render "new"
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "#{@user.proper_name} is updated."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user.active = false
    @user.save!
    redirect_to employees_path
  end

  def display_employees
    @users = User.alphabetical.paginate(:page => params[:page]).per_page(7)
    @employees = @users.employees
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      if current_user && current_user.role?(:admin)
        params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :password_confirmation, :role, :active)  
      else
        params.require(:user).permit(:username, :password, :password_confirmation)
      end
    end
end
