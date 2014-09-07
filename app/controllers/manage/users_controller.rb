class Manage::UsersController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: []
  prepend_before_filter :authenticate_scope!, only: [ :new, :edit, :update, :index, :destroy ]
  before_action :set_user, only: [ :update, :edit, :show, :destroy ]
  # This controller is for managing the user accounts
  #  + creation
  #  + editing
  #  + removing

  # Add access control to all methods (:create, :destroy, etc)
  # TODO

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
  end

  #Overriding user creation
  def create
    puts "creating user"
    build_resource(sign_up_params)
    if resource.save
      puts "Saving user"
      redirect_to manage_users_path
    else
      puts "could not save user"
      clean_up_passwords resource
      respond_with resource
    end
  end

  def update
    # For Rails 4
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # For Rails 3
    # account_update_params = params[:user]

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      #sign_in @user, :bypass => true
      redirect_to manage_user_path(@user)
    else
      render "edit"
    end
  end

  # DELETE 
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to manage_users_path }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
