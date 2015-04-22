class User::AppointmentsController < ApplicationController
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
	# before_action :get_events

	def show
		#@today = DateTime.now.to_i
		@appointment = Appointment.find(params[:id])
		@client = Client.where(:client => @appointment.client).where(:profile => @appointment.profile).first

		today_start = @appointment.start
		today_end = today_start.end_of_day
		@day = today_start

		@schedule= [];
		
		@day_openings = Opening.where(:user => @user).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
    	@day_client_appointments = Appointment.where(:client => @user).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
    	@day_owner_appointments = Appointment.where(:owner => @user).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
		@schedule = @day_openings + @day_client_appointments + @day_owner_appointments

		@schedule.sort_by! do |item|
	      item[:start]
	    end
	end

	def destroy
		@appointment = Appointment.find(params[:id])

		nots = Notification.appointment.where(:event => @appointment.id).destroy_all

		cancellation = Cancellation.new
		cancellation.start = @appointment.start
		cancellation.end = @appointment.end
		cancellation.profile = @appointment.profile
		cancellation.client = @appointment.client
		cancellation.owner = @appointment.owner
		cancellation.save
		
		if @appointment.owner == @user
			n = Notification.new
			n.user = @appointment.client
			n.event = cancellation.id
			n.cancellation!
			n.seen = false
		else
			n = Notification.new
			n.user = @appointment.owner
			n.event = cancellation.id
			n.cancellation!
			n.seen = false
		end
		if @appointment.destroy
			
			n.save
			flash[:success] = "Appointment has been cancelled."
			if request.xhr?
				render js: "document.location = '#{user_schedule_index_path}'"
			else
				redirect_to user_schedule_index_path
			end
		else
			cancellation.destroy
			flash[:error] = "Unable to cancel this appointment at this time."
			if request.xhr?
				render js: "document.location = '#{user_appointment_path(@appointment)}'"
			else
				redirect_to user_appointment_path(@appointment)
			end
			
		end
		
	end

	private

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

	#   def get_events
	#     today_start = DateTime.now.beginning_of_day

	#     @openings = Opening.where(:user => @user).where("start >= ?",today_start).order(:start)
	#     @client_appointments = Appointment.where(:client => @user).order(:start)
	#     @owner_appointments = Appointment.where(:owner => @user).order(:start)

	#     @events = @openings + @client_appointments + @owner_appointments
	#     @events.sort_by! do |item|
	#       item[:start]
	#     end
	#   end

	#   def get_profile_colors
	#   	@colors = []
	#   	@user_is_client.each do |vendor|
	#   		@colors.push(vendor.profile)
	#   	end
	#   	@colors = @colors + @profiles
	#   end

	# def get_client
	# 	@client = Client.find(params[:client_id])
	# end

	# def future_date?
	# 	current_date = DateTime.now.to_i
	# 	start = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p').to_i
	# 	if start > current_date
	# 		return true
	# 	else
	# 		return false
	# 	end
	# end

	# def date_conflict?(dates, start_date, end_date)
	# 	start_date = start_date.to_i
	# 	end_date = end_date.to_i
	# 	dates.each do |date|
	# 		start = date.start.to_i
	# 		ending = date.end.to_i
	# 		if start_date >= start && start_date < ending
	# 			return true
	# 		elsif end_date > start && end_date <= ending
	# 			return true
	# 		end
	# 	end
	# 	return false
	# end

	# def recurring_date(day_num, duration_num)
	# 	day_num = day_num.to_i
	# 	duration_num = duration_num.to_i
	# 	start_datetime = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p')
	# 	end_datetime = DateTime.strptime(safe_params[:end], '%Y/%m/%d %I:%M %p')
	# 	duration_num.times do |k|
	# 		starting = start_datetime + k.weeks
	# 		ending = end_datetime + k.weeks
	# 		#get the day of the week of the start date
	# 		start_datetime_wday = starting.wday
	# 		if day_num > start_datetime_wday
	# 			skip_num = day_num - start_datetime_wday
	# 			next_start_datetime = starting + skip_num.days
	# 			next_end_datetime = ending + skip_num.days
	# 		else
	# 			skip_num = 7 - start_datetime_wday
	# 			next_start_datetime = starting + skip_num.days + day_num.days
	# 			next_end_datetime = ending + skip_num.days + day_num.days
	# 		end
	# 		openings = Opening.where(:user => @user)
	# 		owner_appointments = Appointment.where(:owner => @user)
	# 		client_appointments = Appointment.where(:client => @user)

	# 		opening_conflict = date_conflict?(openings, next_start_datetime, next_end_datetime)
	# 		owner_conflict = date_conflict?(owner_appointments, next_start_datetime, next_end_datetime)
	# 		client_conflict = date_conflict?(client_appointments, next_start_datetime, next_end_datetime)
	# 		if !opening_conflict && !owner_conflict && !client_conflict
	# 			appointment = Appointment.new
	# 			appointment.start = next_start_datetime
	# 			appointment.end = next_end_datetime
	# 			appointment.owner = @user
	# 			appointment.client = @client.client
	# 			appointment.profile = @client.profile
	# 			appointment.save
	# 		else
	# 			flash[:error] = "Some of your appointments where not created because on conflicts."
	# 		end
			
	# 	end
	# end

	# def safe_params
	# 	safe_attributes = [
	# 		:start,
	# 		:end,
	# 	]
	# 	params.require(:appointment).permit(*safe_attributes)
	# end

end