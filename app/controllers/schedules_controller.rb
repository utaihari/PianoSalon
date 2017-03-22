class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /schedules
  # GET /schedules.json
  def index
    @schedules = Schedule.all
    @rooms = Room.all
    @areas = Area.all
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
    @salon = Salon.find(@schedule.salon_id)
    @current_reservations = Reservation.where(schedule_id: @schedule.id).count.to_i
    @is_closed = 1 > (@schedule.recruitment_numbers.to_i - Reservation.where(schedule_id: @schedule.id, condition: 1).count.to_i)
    @reserved = Reservation.find_by(schedule_id: @schedule.id, user_id: current_user.id)
    @owner = User.find(@salon.user_id)
  end

  def calendar
    @room = Room.find(params[:room_id])
    @schedules = Schedule.where(room_id: params[:room_id])
      # start_time: Time.zone.today .. Time.zone.today.next_month.next_month)
      @has_salon = Salon.exists?(current_user.id)
    end

  # GET /schedules/new
  def new
    @salons = Salon.where(user_id: current_user.id)
    @time = Time.parse(params[:datetime])
    @room = Room.find(params[:room_id])
    @schedule = Schedule.new(start_time: @time.to_s(:db), end_time: (@time + 1.hour).to_s(:db), \
      title: @salons[0].salon_name, room_id: params[:room_id])
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule = Schedule.new(schedule_params)
    if schedule_overlapping?(@schedule.salon_id, @schedule.start_time, @schedule.end_time)
      respond_to do |format|
        @salons = Salon.where(user_id: current_user.id)
        format.html { redirect_to :new }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
        return
      end
    end
    respond_to do |format|
      if @schedule.save
        format.html { redirect_to @schedule, notice: 'Schedule was successfully created.' }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_url, notice: 'Schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_schedules
    room_id = params[:room_id]
    schedules = Schedule.where(room_id: room_id)
    output = []
    schedules.each { |s|
      output.push(s)
    }
    render :json => output.to_json
  end

  def check_overlap
    st_array = params[:start_time].split(",")
    st_array.map! { |t| t.to_i }
    start_time = Time.utc(st_array[0], st_array[1], st_array[2], st_array[3], st_array[4], 00)

    et_array = params[:end_time].split(",")
    et_array.map! { |t| t.to_i }
    end_time = Time.utc(et_array[0], et_array[1], et_array[2], et_array[3], et_array[4], 00)

    if 9 < (end_time - start_time) / (60 * 60)
      return render :json => true.to_json
    end

    if 18 < start_time.hour.to_i && start_time.hour.to_i < 24 || \
      0 < start_time.hour.to_i && start_time.hour.to_i < 9
      return render :json => true.to_json
    end

    if 18 < end_time.hour.to_i && end_time.hour.to_i < 24 || \
      0 < end_time.hour.to_i && end_time.hour.to_i < 9
      return render :json => true.to_json
    end

    if start_time >= end_time
      return render :json => true.to_json
    end

    return render :json => schedule_overlapping?(params[:room_id], start_time, end_time).to_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(:salon_id, :start_time, :end_time, :recruitment_numbers, :notes, :title, :room_id)
    end

    def schedule_overlapping?(room_id, start_time, end_time)
      schedules = Schedule.where(room_id: room_id, start_time: start_time - 1.days .. start_time + 1.days )
      # schedules = Schedule.all
      schedules.each { |schedule|
        if start_time <= schedule.start_time && end_time >= schedule.end_time
          return true
        end
      }
      return false
    end
  end
