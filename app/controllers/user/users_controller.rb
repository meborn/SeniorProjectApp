class User::UsersController < ApplicationController
	layout 'user'

	respond_to :html, :js

	before_filter :authenticate_user!

	#These are in application controller
	before_action :get_user_profiles
	before_action :get_notifications
	before_action :get_vendors

	# before_action :get_events

	# before_action :get_upcoming_events
	require 'net/http'
	require 'open-uri'
	require 'json'

	def show
		@schedule= [];
		# @unapproved_clients = Client.where("owner_id = ? AND approved =?", @user.id, false)
		@today_start = DateTime.now.beginning_of_day
		@today_end = DateTime.now.end_of_day
		@today_now = DateTime.now.to_i
	end

	def retrieve_events
		t = params[:today].split('-')
		s = params[:starting].split('-')
		e = params[:ending].split('-')
		@today = DateTime.new(t[0].to_i, t[1].to_i, t[2].to_i).strftime('%B %Y')
		start_date = DateTime.new(s[0].to_i, s[1].to_i, s[2].to_i)
		end_date = DateTime.new(e[0].to_i, e[1].to_i, e[2].to_i).end_of_day

		@openings = Opening.where(:user => @user).where('start >= ? AND end <= ?', start_date, end_date).order(:start)
		@client_appointments = Appointment.where(:client => @user).where('start >= ? AND end <= ?', start_date, end_date).order(:start)
		@owner_appointments = Appointment.where(:owner => @user).where('start >= ? AND end <= ?', start_date, end_date).order(:start)

		@events = @openings + @client_appointments + @owner_appointments
		@events.sort_by! do |item|
			item[:start]
		end
		respond_with(@events, :layout => !request.xhr?)
	end

	private

	# def get_events
	# 	@openings = Opening.where(:user => @user).order(:start)
	# 	@client_appointments = Appointment.where(:client => @user).order(:start)
	# 	@owner_appointments = Appointment.where(:owner => @user).order(:start)

	# end

	# def get_user_profiles
	# 	@user = current_user
	# 	@profiles = Profile.where(user: @user)
	# end

	# def get_notifications
	# 	@appointment_notifications = Notification.appointment.where("user_id = ? AND seen = ?", @user.id, false)
	# 	@client_notifications = Notification.client.where("user_id = ? AND seen = ?", @user.id, false)
	# 	@vender_notifications = Notification.vender.where("user_id = ? AND seen = ?", @user.id, false)
	# end

	# def get_vendors
	# 	get profiles that a user is a client of
	# 	@user_is_client = Client.where("client_id = ? AND approved = ?", @user.id, true)
	# end

	# def get_upcoming_events
	# 	today_start = DateTime.now.beginning_of_day
	# 	today_end = DateTime.now.end_of_day
	# 	@openings = Opening.where("user_id =? AND start >= ? AND start <= ?", @user.id, today_start, today_end).order(:start)
	# 	@owner_appointments = Appointment.where("owner_id =? AND start >=? AND start <= ?", @user.id, today_start, today_end).order(:start)
	# 	@client_appointments = Appointment.where("client_id =? AND start >=? AND start <= ?", @user.id, today_start, today_end).order(:start)
	# 	# @appointments = owner_appointments + client_appointments
	# 	@schedule = Array.new
	# 	@schedule = @schedule + @openings + @owner_appointments + @client_appointments
	# 	@schedule.sort_by! do |item|
	# 		item[:start]
	# 	end
	# end
end