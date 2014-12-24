class API::V1::CompaniesController < API::V1::AddressableController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :set_current_app, only: [:create, :edit, :update, :destroy]
  before_action except: [:show, :index] do
        action = params[:action].upcase
        authenticate_current_app_static(action, "COMPANY")
  end

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    @company.trusted_app = @current_app

    @company.build_address(address_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render action: 'show', status: :created, location: @company }
      else
        format.html { render action: 'new' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update

    respond_to do |format|
      # Optionally update the address, if applicable
      if not params[:address].nil?
        if @company.address.nil?
          if not @company.build_address(address_params).save # Try to create a new one
            format.html { render action: 'edit' }
            format.json { render json: @company.address.errors, status: :unprocessable_entity }
          end
        elsif not @company.address.update(address_params) # Try to edit the existing
          format.html { render action: 'edit' }
          format.json { render json: @company.address.errors, status: :unprocessable_entity }
        end
      end
    
      # Add/remove person
      if not params[:person].nil? then
          set_person params[:person][:id]
          action = params[:person][:action]
          if action == 'add'
            @company.people << @person
          elsif action == 'remove'
            @company.people.delete(@person)
          else
            format.html { render action: 'edit' }
            format.json { render json: { :error => "Invalid Action" }, status: :unprocessable_entity }
          end
      end

      if params[:company].nil? || @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    if not @company.address.nil?
      @company.address.destroy
    end

    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      # Companies are looked up by their name
      @company = Company.where(name: params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :average_rating, :phone_number)
    end

    def set_person id
        @person = Person.find(id)
    end
end
