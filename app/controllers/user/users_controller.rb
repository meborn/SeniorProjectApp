class User::UsersController < ApplicationController
	layout 'user'

	respond_to :html, :js

	before_filter :authenticate_user!

	#in application controller
	before_action :get_user
	before_action :get_user_profiles
	before_action :get_notifications
	before_action :get_vendors
	before_action :get_profile_colors
	#in application controller
	
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

end