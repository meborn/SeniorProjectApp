class User::UsersController < ApplicationController
	layout 'user'

	respond_to :html, :js

	before_filter :authenticate_user!

	before_action :get_user
	before_action :get_user_profiles
	before_action :get_notifications
	before_action :get_vendors
	before_action :get_events
	before_action :get_profile_colors
	

	require 'net/http'
	require 'open-uri'
	require 'json'

	def show
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

end