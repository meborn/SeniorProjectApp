class User::AppointmentsController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	before_action :get_user
	before_action :get_client, only: [:new,:create]

	def show
		@today = DateTime.now.to_i
		@appointment = Appointment.find(params[:id])
		@client = Client.where(:client => @appointment.client).where(:profile => @appointment.profile).first
	end

	def destroy
		
	end

	# def new
	# 	@appointment = Appointment.new
	# 	@openings = Opening.where(:user => @user)
	# 	@client_appointments = Appointment.where(:client => @user)
	# 	@owner_appointments = Appointment.where(:owner => @user)
	# 	@events = @openings + @client_appointments + @owner_appointments
	# 	@events.sort_by! do |item|
	# 		item[:start]
	# 	end
	# end

	# def create
	# 	start_datetime = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p')
	# 	end_datetime = DateTime.strptime(safe_params[:end], '%Y/%m/%d %I:%M %p')
	# 	client = @client
	# 	if end_datetime.to_i <= start_datetime.to_i
	# 		flash[:error] = "End DateTime must be after Start DateTime."
	# 		redirect_to new_user_appointment_path
	# 	elsif future_date?
	# 		openings = Opening.where(:user => @user)
	# 		owner_appointments = Appointment.where(:owner => @user)
	# 		client_appointments = Appointment.where(:client => @user)

	# 		opening_conflict = date_conflict?(openings, start_datetime, end_datetime)
	# 		owner_conflict = date_conflict?(owner_appointments, start_datetime, end_datetime)
	# 		client_conflict = date_conflict?(client_appointments, start_datetime, end_datetime)
	# 		if !opening_conflict && !owner_conflict && !client_conflict
	# 			@appointment = Appointment.new
	# 			@appointment.start = start_datetime
	# 			@appointment.end = end_datetime
	# 			@appointment.owner = @user
	# 			@appointment.client = client.client
	# 			@appointment.profile = client.profile
	# 			if @appointment.save
	# 				if params[:sunday].present?
	# 					recurring_date(params[:sunday], params[:duration_num])
	# 				end
	# 				if params[:monday].present?
	# 					recurring_date(params[:monday], params[:duration_num])
	# 				end
	# 				if params[:tuesday].present?
	# 					recurring_date(params[:tuesday], params[:duration_num])
	# 				end
	# 				if params[:wednesday].present?
	# 					recurring_date(params[:wednesday], params[:duration_num])
	# 				end
	# 				if params[:thursday].present?
	# 					recurring_date(params[:thursday], params[:duration_num])
	# 				end
	# 				if params[:friday].present?
	# 					recurring_date(params[:friday], params[:duration_num])
	# 				end
	# 				if params[:saturday].present?
	# 					recurring_date(params[:saturday], params[:duration_num])
	# 				end
	# 				flash[:success] = "Appointment Saved!"
	# 				redirect_to user_client_path(client)
	# 			else
	# 				flash[:error] = "Unable to Save Opening!"
	# 				render 'new'
	# 			end
	# 		else
	# 			if opening_conflict
	# 				flash[:error] = "Unable to save appointment. You have an opening that conflicts."
	# 			else
	# 				flash[:error] = "Unable to save appointment. You have another appointment that conflicts."
	# 			end
	# 			redirect_to new_user_client_appointment_path	
	# 		end
	# 	else
	# 		flash[:error] = "You can't make appointments in the past."
	# 		redirect_to new_user_client_appointment_path
	# 	end
	# end

	private

	def get_user
		@user = current_user
	end

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