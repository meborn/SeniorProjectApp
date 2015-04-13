class UsersController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	require 'net/http'
	require 'open-uri'
	require 'json'

	def show
		@user = User.find(params[:id])
		@profiles = Profile.where(user: @user)

		# @unapproved_clients = Client.where("owner_id = ? AND approved =?", @user.id, false)

		# @appointment_notifications = Notification.appointment.where("user_id = ? AND seen = ?", @user.id, false)
		# @client_notifications = Notification.client.where("user_id = ? AND seen = ?", @user.id, false)
		# @vender_notifications = Notification.vender.where("user_id = ? AND seen = ?", @user.id, false)
		# # get profiles that a user is a client of
		# @user_is_client = Client.where("client_id = ? AND approved = ?", @user.id, true)
		

		# @today_start = DateTime.now.beginning_of_day
		# @today_end = DateTime.now.end_of_day
		# @today_now = DateTime.now.to_i

		# @openings = Opening.where(user: @user).order(:start).take(5)
		# owner_appointments = Appointment.where(:owner => @user).order(:start).take(5)
		# client_appointments = Appointment.where(:client => @user).order(:start).take(5)
		# @appointments = owner_appointments + client_appointments
		# @schedule = Array.new
		# @schedule = @schedule + @openings + @appointments
		# @schedule.sort_by! do |item|
		# 	item[:start]
		# end
		
	end
end