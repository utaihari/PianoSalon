class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    @user = User.find(@reservation.user_id)
    @schedule = Schedule.find(@reservation.schedule_id)
    @salon = Salon.find(@schedule.salon_id)
    @owner = User.find(@salon.user_id)
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    if params[:schedule_id] == nil
      redirect_to root_path and return
    end

    @schedule = Schedule.find(params[:schedule_id])
    is_closed = 1 > (@schedule.recruitment_numbers.to_i - Reservation.where(schedule_id: @schedule.id, condition: 1).count.to_i)
    condition = 0
    if is_closed
      condition = 2
    end

    @reservation = Reservation.new(user_id: current_user.id, schedule_id: params[:schedule_id], condition: condition)

    respond_to do |format|
      if @reservation.save
        title = "#{current_user.user_name}さんがあなたのサロンを予約しました。"
        description = "<p>#{current_user.user_name}さんがあなたのサロンを予約しました。</p><p><a href=\"/reservations/#{@reservation.id}\">予約を確定するにはここをクリック</a></p>"

        salon = Salon.find(@schedule.salon_id)
        Notice.create(title: title, description: description, user_id: salon.user_id)

        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    @reservation = Reservation.find(params[:id])
    @schedule = Schedule.find(@reservation.schedule_id)
    @salon = Salon.find(@schedule.salon_id)
    @owner = User.find(@salon.user_id)
    @room = Room.find(@salon.room_id)
    approve = params[:approve]
    if approve
      title = "#{salon.salon_name}の予約が承認されました"
      description = "<p>#{salon.salon_name}の予約が承認されました</p><p>#{@room.room_name}にて#{@schedule.start_time.day}日にお待ちしております。</p>
      <p>#{@schedule.note}</p><p><a href=\"/reservations/#{@reservation.id}\">詳細を確認するにはここをクリック</a></p>"
      @reservation.condition = 1
      @reservation.save
    else
      title = "#{salon.salon_name}の予約は承認されませんでした。"
      description = "<p>申し訳ございません。</p><p>#{salon.salon_name}の予約は承認されませんでした。</p><p>次回の予約をお待ちしております。</p>"
      @reservation.destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:user_id, :schedule_id, :condition)
    end
  end
