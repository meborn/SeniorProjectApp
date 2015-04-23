class ProfilesController < ApplicationController

	layout 'user'
	respond_to :html, :js

	before_filter :authenticate_user!
	#application controller
	before_action :get_user
	before_action :get_user_profiles
	before_action :get_notifications
	before_action :get_vendors
	before_action :get_profile_colors
	
	#application controller
	before_action :get_profile, only: [:show, :retrieve_events]
	# before_action :get_events, only: [:show]
	before_action :is_client, only: [:show]
	def index
		if !params[:zip].blank?
			response = JSON.parse(open('http://ziptasticapi.com/' + params[:zip]).read)
			if response['city'] == nil || response['state'] == nil
				@profiles = Profile.all
				@bad_zip = true
				@no_zip = false
			else
				@city = response['city']
				@state = response['state']
				@profiles = Profile.where(:city => @city).where(:state => @state)
				@bad_zip = false
				@no_zip = false
			end
		else
			@profiles = Profile.all
			@bad_zip = false
			@no_zip = true
		end
	end

	def show
		# today_start = DateTime.now.beginning_of_day
		# today_end = today_start.end_of_day
		# @day = today_start

		# @schedule= [];
		
		# @day_openings = Opening.where(:profile => @profile).where("start >= ? AND start <= ?",today_start, today_end).order(:start)
		# @schedule = @day_openings
		
	end

	# def retrieve_events
	# 	date = params[:date]
	# 	date_list = date.split("_")
	# 	y = date_list[0].to_i
	# 	m = date_list[1].to_i + 1
	# 	d = date_list[2].to_i

	# 	date_start = DateTime.new(y, m, d).beginning_of_day
	# 	date_end = date_start.end_of_day
	# 	@day = date_start

	# 	@schedule= [];
		
	# 	@day_openings = Opening.where(:profile => @profile).where("start >= ? AND start <= ?",date_start, date_end).order(:start)
	# 	@schedule = @schedule + @day_openings

	#     respond_with(@schedule, :layout => !request.xhr?)
	# end

	private

	def get_profile
		@profile = Profile.find(params[:id])
	end

	def get_events
	    today_start = DateTime.now.beginning_of_day
	    
	    # @openings = Opening.where(:user => @user).where("start >= ?",today_start).order(:start)
	    @openings = Opening.where(:profile => @profile).order(:start)

	    @events = @openings
	  end

	def is_client()
		client = Client.where("profile_id = ? AND client_id = ?", @profile, @user).first
		if client
			@client = nil
			@is_client = client.approved?	
		else
			@client = Client.new
			@is_client = false
		end

	end
end