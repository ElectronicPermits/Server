class StaticPermissionsController < ApplicationController
  before_action :set_static_permission, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @static_permissions = StaticPermission.all
    respond_with(@static_permissions)
  end

  def show
    respond_with(@static_permission)
  end

  def new
    @static_permission = StaticPermission.new
    respond_with(@static_permission)
  end

  def edit
  end

  def create
    @static_permission = StaticPermission.new(static_permission_params)
    @static_permission.save
    respond_with(@static_permission)
  end

  def update
    @static_permission.update(static_permission_params)
    respond_with(@static_permission)
  end

  def destroy
    @static_permission.destroy
    respond_with(@static_permission)
  end

  private
    def set_static_permission
      @static_permission = StaticPermission.find(params[:id])
    end

    def static_permission_params
      params.require(:static_permission).permit(:permission_type, :target)
    end
end
