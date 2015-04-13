class User::ScheduleController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	before_action :get_user
	before_action :get_profiles

	before_action :get_year, only: [:index]
	before_action :get_month, only: [:index]
	before_action :get_day, only: [:index]

	before_action :get_dates, only: [:index]
	before_action :get_openings, only: [:index]
	before_action :get_appointments, only: [:index]

	def index
		@month_events = @openings_month + @appointments_month
		@month_events.sort_by! do |item|
			item[:start]
		end
		@date_events = @openings_on_date + @appointments_on_date
		@date_events.sort_by! do |item|
			item[:start]
		end
	end

	private

	def get_user
		@user = current_user
	end

	def get_profiles
		@profiles = Profile.where(:user => @user) + Profile.includes(:appointments).where(appointments: {:client => @user})
	end

	def get_year
		# if year params set year else set to current year
		if !params[:year].blank?
			@year = params[:year].to_i
		else
			@year = Date.today.year.to_i
		end
	end

	def get_month
		# if month params set month else set to current month
		if !params[:month].blank?
			@month = params[:month].to_i
		else
			@month = Date.today.month.to_i
		end
	end

	def get_day
		# if day params set day else set to current day
		if !params[:day].blank?
			@day = params[:day].to_i
		else
			@day = Date.today.day.to_i
		end
	end

	def get_dates
		@start_date = DateTime.new(@year, @month, 1).beginning_of_week(:sunday)

		@end_date = DateTime.new(@year, @month, 1).end_of_month

		@date = DateTime.new(@year, @month, @day)
	end

	def get_appointments
		@openings_month = Opening.where(:user => @user).where("start >= ? AND start <= ?", @start_date.beginning_of_day, @end_date.end_of_day).order(:start)
		@openings_on_date = Opening.where(:user => @user).where("start >= ? AND start <=?", @date.beginning_of_day, @date.end_of_day).order(:start)
	end

	def get_openings
		@appointments_month = Appointment.where(:owner => @user).where("start >= ? AND start <=?", @start_date.beginning_of_day, @end_date.end_of_day).order(:start) + Appointment.where(:client => @user).where("start >= ? AND start <=?", @start_date.beginning_of_day, @end_date.end_of_day).order(:start)
		@appointments_on_date = Appointment.where(:owner => @user).where("start >= ? AND start <=?", @date.beginning_of_day, @date.end_of_day).order(:start) + Appointment.where(:client => @user).where("start >= ? AND start <=?", @date.beginning_of_day, @date.end_of_day).order(:start)
	end
end