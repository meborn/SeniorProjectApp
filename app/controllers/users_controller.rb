class UsersController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	require 'net/http'
	require 'open-uri'
	require 'json'

	def show
		@user = current_user
		@profiles = Profile.where(user: @user)
		@today_start = DateTime.now.beginning_of_day
		@today_end = DateTime.now.end_of_day
		@today_now = DateTime.now.to_i
		@openings = Opening.where(user: @user).where("start > ?", @today_start).where("start < ?", @today_end).order(:start)
		
		@appointments = Appointment.where(:user => @user)
	end
end