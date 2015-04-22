class OpeningsController < ApplicationController

	layout 'user'
	respond_to :html, :js

	before_filter :authenticate_user!
	before_action :get_profile
	before_action :get_owner
	

	#application controller
	before_action :get_user
	before_action :get_user_profiles
	before_action :get_notifications
	before_action :get_vendors
	before_action :get_profile_colors
	
	#application controller
	before_action :get_events, only: [:index]

	def index
		#current_date = DateTime.now.beginning_of_day
		#@openings = Opening.where(:profile => @profile).where("start >= ?", current_date).order(:start)

		today_start = DateTime.now.beginning_of_day
		today_end = today_start.end_of_day
		@day = today_start

		@schedule= [];
		
		@day_openings = Opening.where(:profile => @profile).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
		@schedule = @day_openings
	end

	def retrieve_events
		date = params[:date]
		date_list = date.split("_")
		y = date_list[0].to_i
		m = date_list[1].to_i + 1
		d = date_list[2].to_i

		date_start = DateTime.new(y, m, d).beginning_of_day
		date_end = date_start.end_of_day
		@day = date_start

		@schedule= [];
		
		@day_openings = Opening.where(:profile => @profile).where("start >= ? AND start <= ?",date_start, date_end).order(:start)
		@schedule = @schedule + @day_openings

	    respond_with(@schedule, :layout => !request.xhr?)
	end

	private

	def get_user
		@user = current_user
	end

	def get_profile
		@profile = Profile.find(params[:profile_id])
	end

	def get_owner
		@owner = @profile.user
	end

	def get_events
	    today_start = DateTime.now.beginning_of_day
	    
	    # @openings = Opening.where(:user => @user).where("start >= ?",today_start).order(:start)
	    @openings = Opening.where(:profile => @profile).order(:start)

	    @events = @openings
	  end
end