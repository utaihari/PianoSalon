class PagesController < ApplicationController
	def index
		@areas = Area.all
		@next_schedules = Schedule.where(start_time: Time.zone.today .. Time.zone.today.next_month)
	end

	def show
		@notices = Notice.where(user_id: current_user.id, is_checked: false)
		@my_salons = Salon.all
		@unapproved_sarons = Salon.where(approval: false)
	end

	def notices
		@notices = Notice.where(user_id: current_user.id)
	end

	def notice_show
		@notice = Notice.find(params[:id])
		@notice.is_checked = true
		@notice.save
	end

	def notice_destroy
		@notice = Notice.find(params[:id])
		@notice.destroy
		respond_to do |format|
			format.html { redirect_to notices_url, notice: '削除しました。' }
			format.json { head :no_content }
		end
	end
end
