class API::V1::ViolationsController < API::V1::BaseController
  before_action :set_violation, only: [:show, :edit, :update, :destroy]
  before_action only: [:update] do
      # Retrieve the permit number from violation
      params[:permit_number] = @violation.permit.permit_number
  end
  before_action :set_permit, only: [:create, :update]
  before_action :set_current_app, only: [:create, :update, :edit, :destroy]
  before_action only: [:create, :update, :edit] do
      authenticate_current_app(Permission.permission_types[:MANAGE_VIOLATIONS])
  end

  # GET /violations
  # GET /violations.json
  def index
    @violations = Violation.all
  end

  # GET /violations/1
  # GET /violations/1.json
  def show
  end

  # GET /violations/new
  def new
    @violation = Violation.new
  end

  # GET /violations/1/edit
  def edit
  end

  # POST /violations
  # POST /violations.json
  def create
    @violation = Violation.new(violation_params)
    @violation.permit = @permit
    @violation.trusted_app = @current_app

    respond_to do |format|
      if @violation.save
        format.json { render action: 'show', status: :created, location: api_v1_violation_url(@violation) }
      else
        format.json { render json: @violation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /violations/1
  # PATCH/PUT /violations/1.json
  def update
    respond_to do |format|
      if @violation.update(violation_params)
        format.json { head :no_content }
      else
        format.json { render json: @violation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /violations/1
  # DELETE /violations/1.json
  def destroy
    @violation.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_violation
      @violation = Violation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def violation_params
      params.require(:violation).permit(:name, :description, :ordinance, :issue_date, :open)
    end
end
