class User::NotificationsController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	#application controller
	before_action :get_user
	before_action :get_user_profiles
	before_action :get_notifications
	before_action :get_vendors
	before_action :get_profile_colors
	#application controller

	def index
		appointments_not = Notification.appointment.where(:user => @user).where(:seen => false)
		@appointments = []
		appointments_not.each do |n|
			# n.seen = true
			# n.save
			appointment = Appointment.find(n.event)
			@appointments.push(appointment)
		end
	end

	def new_appointments
		appointments_not = Notification.appointment.where(:user => @user).where(:seen => false)
		@appointments = []
		appointments_not.each do |n|
			# n.seen = true
			# n.save
			appointment = Appointment.find(n.event)
			@appointments.push(appointment)
			n.destroy
		end
	end

	def cancellations
		cancellation_not = Notification.cancellation.where(:user => @user).where(:seen => false)
		@cancellations = []
		cancellation_not.each do |n|
			cancellation = Cancellation.find(n.event)
			@cancellations.push(cancellation)
			n.destroy
		end
	end

	def new_venders
		vender_not = Notification.vender.where(:user => @user).where(:seen => false)
		@venders = []
		vender_not.each do |n|
			profile = Client.find(n.event).profile
			@venders.push(profile)
			n.destroy
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

	# def get_notifications
	# 	@appointment_notifications = Notification.appointment.where("user_id = ? AND seen = ?", @user.id, false)
	# 	@client_notifications = Notification.client.where("user_id = ? AND seen = ?", @user.id, false)
	# 	@vender_notifications = Notification.vender.where("user_id = ? AND seen = ?", @user.id, false)
	# end
	
end