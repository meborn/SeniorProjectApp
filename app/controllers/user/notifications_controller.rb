class User::NotificationsController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	before_action :get_user
	before_action :get_notifications

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
		end
	end

	def new_clients
		clients_not = Notification.client.where(:user => @user).where(:seen => false)
		@clients = []
		clients_not.each do |n|
			client = Client.find(n.event)
			@clients.push(client)
		end
	end

	def new_venders
		vender_not = Notification.vender.where(:user => @user).where(:seen => false)
		@venders = []
		vender_not.each do |n|
			profile = Client.find(n.event).profile
			@venders.push(profile)
		end
	end

	private

	def get_user
	    @user = current_user
	  end

	  def get_notifications
	    @appointment_notifications = Notification.appointment.where("user_id = ? AND seen = ?", @user.id, false)
	    @client_notifications = Notification.client.where("user_id = ? AND seen = ?", @user.id, false)
	    @vender_notifications = Notification.vender.where("user_id = ? AND seen = ?", @user.id, false)
	  end

	  def get_user_profiles
	    @user = current_user
	    @profiles = Profile.where(user: @user)
	  end

	  def get_vendors
	    # get profiles that a user is a client of
	    @user_is_client = Client.where("client_id = ? AND approved = ?", @user.id, true)
	  end

	  def get_events
	    today_start = DateTime.now.beginning_of_day

	    @openings = Opening.where(:user => @user).where("start >= ?",today_start).order(:start)
	    @client_appointments = Appointment.where(:client => @user).order(:start)
	    @owner_appointments = Appointment.where(:owner => @user).order(:start)

	    @events = @openings + @client_appointments + @owner_appointments
	    @events.sort_by! do |item|
	      item[:start]
	    end
	  end

	  def get_profile_colors
	  	@colors = []
	  	@user_is_client.each do |vendor|
	  		@colors.push(vendor.profile)
	  	end
	  	@colors = @colors + @profiles
	  end

	def get_notifications
		@appointment_notifications = Notification.appointment.where("user_id = ? AND seen = ?", @user.id, false)
		@client_notifications = Notification.client.where("user_id = ? AND seen = ?", @user.id, false)
		@vender_notifications = Notification.vender.where("user_id = ? AND seen = ?", @user.id, false)
	end
	
end