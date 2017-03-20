class SalonsController < ApplicationController
  before_action :set_salon, only: [:show, :edit, :update, :destroy]

  # GET /salons
  # GET /salons.json
  def index
    @salons = Salon.where(approval: true)
  end

  # GET /salons/1
  # GET /salons/1.json
  def show
    @organizer_name = User.find(@salon.user_id).user_name
    @next_schedules = Schedule.where(salon_id: @salon.id, start_time: Time.zone.today .. Time.zone.today.next_month)
  end

  # GET /salons/new
  def new
    @salon = Salon.new
    @areas = Area.all
  end

  # GET /salons/1/edit
  def edit
    @areas = Area.all
  end

  # POST /salons
  # POST /salons.json
  def create
    @salon = Salon.new(salon_params)

    respond_to do |format|
      if @salon.save
        format.html { redirect_to @salon, notice: 'Salon was successfully created.' }
        format.json { render :show, status: :created, location: @salon }
      else
        format.html { render :new }
        format.json { render json: @salon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /salons/1
  # PATCH/PUT /salons/1.json
  def update
    respond_to do |format|
      if @salon.update(salon_params)
        format.html { redirect_to @salon, notice: 'Salon was successfully updated.' }
        format.json { render :show, status: :ok, location: @salon }
      else
        format.html { render :edit }
        format.json { render json: @salon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /salons/1
  # DELETE /salons/1.json
  def destroy
    @salon.destroy
    respond_to do |format|
      format.html { redirect_to salons_url, notice: 'Salon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def manage
    if !current_user.admin
      format.html { redirect_to @salon, notice: '管理者ではありません' }
      format.json { render :show, status: :ok, location: @salon }
    end
    @notice = Notice.new(description: "")
    @salon = Salon.find(params[:id])
    @user_id = @salon.user_id
  end

  def manage_update
    if !current_user.admin
      format.html { redirect_to @salon, notice: '管理者ではありません' }
      format.json { render :show, status: :ok, location: @salon }
    end

    description = params[:notice][:description]
    title = params[:notice][:title]
    user_id = params[:notice][:user_id]

    Notice.create(description: description, title: title, user_id: user_id)

    @salon = Salon.find(params[:salon][:id])
    if params[:salon][:approval]
      @salon.approval = true
      @salon.save
      format.html { redirect_to @salon, notice: 'Salon was successfully updated.' }
      format.json { render :show, status: :ok, location: @salon }
    else
      @salon.delete
      format.html { redirect_to salons_url, notice: '申請を削除しました' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_salon
      @salon = Salon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def salon_params
      params.require(:salon).permit(:id, :user_id, :salon_name, :description, :area_id, :approval)
      params.require(:notice).permit(:user_id, :title, :description)

    end
  end
