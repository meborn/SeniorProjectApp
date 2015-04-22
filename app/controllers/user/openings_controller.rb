class User::OpeningsController < ApplicationController
	layout 'user'

	respond_to :html, :js


	before_filter :authenticate_user!
	
	#application controller
	before_action :get_user
	before_action :get_user_profiles
	before_action :get_notifications
	before_action :get_vendors
	before_action :get_profile_colors
	#application controller
	
	before_action :get_events
	

	
	def show
		@opening = Opening.find(params[:id])
		today_start = @opening.start.beginning_of_day
		today_end = today_start.end_of_day
		@day = today_start

		@schedule= [];
		
		@day_openings = Opening.where(:user => @user).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
    	@day_client_appointments = Appointment.where(:client => @user).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
    	@day_owner_appointments = Appointment.where(:owner => @user).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
		@schedule = @schedule + @day_openings + @day_client_appointments + @day_owner_appointments

		@schedule.sort_by! do |item|
	      item[:start]
	    end
	end

	def new
		@opening = Opening.new

		today_start = DateTime.now.beginning_of_day
		today_end = today_start.end_of_day
		@day = today_start

		@schedule= [];
		
		@day_openings = Opening.where(:user => @user).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
    	@day_client_appointments = Appointment.where(:client => @user).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
    	@day_owner_appointments = Appointment.where(:owner => @user).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
		@schedule = @schedule + @day_openings + @day_client_appointments + @day_owner_appointments

		@schedule.sort_by! do |item|
	      item[:start]
	    end
	end

	def create
		start_datetime = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p')
		end_datetime = DateTime.strptime(safe_params[:end], '%Y/%m/%d %I:%M %p')
		if end_datetime.to_i <= start_datetime.to_i
			flash[:error] = "End Date must be after Start Date."
			redirect_to new_user_opening_path
		else
			# openings = Opening.where(:user => @user)
			# owner_appointments = Appointment.where(:owner => @user)
			# client_appointments = Appointment.where(:client => @user)

			opening_conflict = date_conflict?(@openings, start_datetime, end_datetime)
			owner_conflict = date_conflict?(@owner_appointments, start_datetime, end_datetime)
			client_conflict = date_conflict?(@client_appointments, start_datetime, end_datetime)
			if !opening_conflict && !owner_conflict && !client_conflict
				@opening = Opening.new
				@opening.start = start_datetime
				@opening.end = end_datetime
				@opening.user = @user
				@opening.profile_id = safe_params[:profile]
				if @opening.save
					flash[:success_list] = 1
					#flash[:success_list] = "#{@opening.profile.title}|#{@opening.start.strftime('%m/%d/%Y')}|#{@opening.start.strftime('%l:%M')}|#{@opening.end.strftime('%l:%M %p')}"
					flash[:error_list] = 0

					
					if params[:sunday].present?
						recurring_date(params[:sunday], params[:duration_num])
					end
					if params[:monday].present?
						recurring_date(params[:monday], params[:duration_num])
					end
					if params[:tuesday].present?
						recurring_date(params[:tuesday], params[:duration_num])
					end
					if params[:wednesday].present?
						recurring_date(params[:wednesday], params[:duration_num])
					end
					if params[:thursday].present?
						recurring_date(params[:thursday], params[:duration_num])
					end
					if params[:friday].present?
						recurring_date(params[:friday], params[:duration_num])
					end
					if params[:saturday].present?
						recurring_date(params[:saturday], params[:duration_num])
					end

					if flash[:error_list] == 0
						flash.delete(:error_list)
					else
						flash[:error_list] = flash[:error_list] + 1
					end
					# flash[:success] = "Opening Saved!"
					redirect_to user_schedule_index_path
				else
					flash[:error] = "Pick a profile for this opening!"
					redirect_to new_user_opening_path
				end
			else
				if opening_conflict
					flash[:error] = "You have another opening that conflicts!"
				else
					flash[:error] = "You have an appointment that conflicts!"
				end
				redirect_to new_user_opening_path(@opening)	
			end
		end
	end

	def update
		@opening = Opening.find(params[:id])

		start_datetime = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p')
		end_datetime = DateTime.strptime(safe_params[:end], '%Y/%m/%d %I:%M %p')

		if end_datetime.to_i <= start_datetime.to_i
			flash[:error] = "End Date must be after Start Date."
			redirect_to user_opening_path(@opening)
		else
			@openings = Opening.where(:user => @user).where("id != ?", @opening.id)
			# @owner_appointments = Appointment.where(:owner => @user)
			# @client_appointments = Appointment.where(:client => @user)

			opening_conflict = date_conflict?(@openings, start_datetime, end_datetime)
			owner_conflict = date_conflict?(@owner_appointments, start_datetime, end_datetime)
			client_conflict = date_conflict?(@client_appointments, start_datetime, end_datetime)
			if !opening_conflict && !owner_conflict && !client_conflict
				@opening.start = start_datetime
				@opening.end = end_datetime
				if @opening.save
					flash[:success] = "Changes Saved!"
					redirect_to user_opening_path(@opening)
				else
					flash[:error] = "Unable to Save Changes!"
					redirect_to user_opening_path(@opening)
				end
			else
				flash[:error] = "Unable to Save Changes! There is a conflict with another opening or appointment."
				redirect_to user_opening_path(@opening)
			end
		end
	end

	def destroy
		@opening = Opening.find(params[:id])
		month = @opening.start.strftime('%m').to_i
		day = @opening.start.strftime('%d').to_i
		year = @opening.start.strftime('%Y').to_i
		if @opening.destroy
			flash[:success] = "Opening Deleted!"
		else
			flash[:error] = "Unable to delete opening!"
		end
		if request.xhr?
			render js: "document.location = '#{user_schedule_index_path}?month=#{month}&day=#{day}&year=#{year}'"
		else
			redirect_to user_schedule_index_path
		end
	end

	def delete_recurring
		opening = Opening.find(params[:opening_id])
		month = opening.start.strftime('%m').to_i
		day = opening.start.strftime('%d').to_i
		year = opening.start.strftime('%Y').to_i
		openings = Opening.where(:user => @user).where("start >= ?", opening.start)
		count = 0;
		openings.each do |o|
			if o.start.strftime('%A') == opening.start.strftime('%A') && o.start.strftime('%I:%M') == opening.start.strftime('%I:%M') && o.end.strftime('%I:%M') == opening.end.strftime('%I:%M')
				o.destroy
				count += 1;
			end
		end
		flash[:success] = "#{count} openings deleted"
		if request.xhr?
			render js: "document.location = '#{user_schedule_index_path}?month=#{month}&day=#{day}&year=#{year}'"
		else
			redirect_to user_schedule_index_path
		end
	end

	def retrieve_events
		date = params[:date]
		date_list = date.split("_")
		y = date_list[0].to_i
		m = date_list[1].to_i + 1
		d = date_list[2].to_i

		date_start = DateTime.new(y, m, d).beginning_of_day
		date_end = date_start.end_of_day
		@day = date_start

		@schedule= [];
		
		@day_openings = Opening.where(:user => @user).where("start >= ? AND start <= ?",date_start, date_end).order(:start)
    	@day_client_appointments = Appointment.where(:client => @user).where("start >= ? AND start <= ?",date_start, date_end).order(:start)
    	@day_owner_appointments = Appointment.where(:owner => @user).where("start >= ? AND start <= ?",date_start, date_end).order(:start)
		@schedule = @schedule + @day_openings + @day_client_appointments + @day_owner_appointments

		@schedule.sort_by! do |item|
	      item[:start]
	    end
	    respond_with(@schedule, :layout => !request.xhr?)
	end

	private

	# def future_date?
	# 	current_date = DateTime.now.to_i
	# 	start = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p').to_i
	# 	if start > current_date
	# 		return true
	# 	else
	# 		return false
	# 	end
	# end

	def date_conflict?(dates, start_date, end_date)
		start_date = start_date.to_i
		end_date = end_date.to_i
		dates.each do |date|
			start = date.start.to_i
			ending = date.end.to_i
			if start_date >= start && start_date < ending
				return true
			elsif end_date > start && end_date <= ending
				return true
			end
		end
		return false
	end

	def recurring_date(day_num, duration_num)
		flash[:error_list] = flash[:error_list] + 1
		day_num = day_num.to_i
		
		start_datetime = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p')
		end_datetime = DateTime.strptime(safe_params[:end], '%Y/%m/%d %I:%M %p')
		if day_num < start_datetime.wday
			duration_num = duration_num.to_i - 1
		else
			duration_num = duration_num.to_i + 1
		end
		
		duration_num.times do |k|
			if day_num < start_datetime.wday
				w = k
				new_start = start_datetime + ((day_num-start_datetime.wday) % 7) + w.weeks
				new_end = end_datetime + ((day_num-end_datetime.wday) % 7) + w.weeks
			else
				w = k - 1
				if k == 0
					new_start = start_datetime + ((day_num-start_datetime.wday) % 7)
					new_end = end_datetime + ((day_num-end_datetime.wday) % 7)
				else
					new_start = start_datetime + ((day_num-start_datetime.wday) % 7) + w.weeks
					new_end = end_datetime + ((day_num-end_datetime.wday) % 7) + w.weeks
				end
			end
			openings = Opening.where(:user => @user)
			owner_appointments = Appointment.where(:owner => @user)
			client_appointments = Appointment.where(:client => @user)

			opening_conflict = date_conflict?(openings, new_start, new_end)
			owner_conflict = date_conflict?(owner_appointments, new_start, new_end)
			client_conflict = date_conflict?(client_appointments, new_start, new_end)
			if !opening_conflict && !owner_conflict && !client_conflict
				opening = Opening.new
				opening.start = new_start
				opening.end = new_end
				opening.user = @user
				opening.profile_id = safe_params[:profile]
				if opening.save
					#item = ",#{opening.profile.title}|#{opening.start.strftime('%m/%d/%Y')}|#{opening.start.strftime('%l:%M')}|#{opening.end.strftime('%l:%M %p')}"
					flash[:success_list] = flash[:success_list] + 1
					flash[:error_list] = flash[:error_list] - 1
				end
				
			end
			
		end
		
	end

	# def get_user
	#     @user = current_user
	#   end

	#   def get_notifications
	#     @appointment_notifications = Notification.appointment.where("user_id = ? AND seen = ?", @user.id, false)
	#     @client_notifications = Notification.client.where("user_id = ? AND seen = ?", @user.id, false)
	#     @vender_notifications = Notification.vender.where("user_id = ? AND seen = ?", @user.id, false)
	#   end

	#   def get_user_profiles
	#     @user = current_user
	#     @profiles = Profile.where(user: @user)
	#   end

	#   def get_vendors
	    
	#     @user_is_client = Client.where("client_id = ? AND approved = ?", @user.id, true)
	#   end

	  def get_events
	    @today_start = DateTime.now.beginning_of_day

	    @openings = Opening.where(:user => @user).where("start >= ?",@today_start).order(:start)
	    @client_appointments = Appointment.where(:client => @user).order(:start)
	    @owner_appointments = Appointment.where(:owner => @user).order(:start)

	    @events = @openings + @client_appointments + @owner_appointments
	    @events.sort_by! do |item|
	      item[:start]
	    end
	  end

	  # def get_profile_colors
	  # 	@colors = []
	  # 	@user_is_client.each do |vendor|
	  # 		@colors.push(vendor.profile)
	  # 	end
	  # 	@colors = @colors + @profiles
	  # end

	def safe_params
		safe_attributes = [
			:start,
			:end,
			:profile,
		]
		params.require(:opening).permit(*safe_attributes)
	end

end