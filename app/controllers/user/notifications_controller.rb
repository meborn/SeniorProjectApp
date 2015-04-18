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
	
end