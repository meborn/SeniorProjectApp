class User::ProfilesController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	
	before_action :get_user
	before_action :get_user_profiles
	before_action :get_notifications
	before_action :get_vendors
	before_action :get_events
	before_action :get_profile_colors



	require 'open-uri'
	require 'json'

	def index
		@profiles = Profile.where(:user => @user)
	end

	def show
		@rating = 4
		@profile = Profile.find(params[:id])
	end

	def new
		@profile = Profile.new
	end

	def create
		@profile = Profile.new(safe_params)
		@profile.user = current_user
		if @profile.save
			response = JSON.parse(open('http://ziptasticapi.com/' + @profile.zip).read)
			@profile.city = response['city']
			@profile.state = response['state']
			if @profile.save 
				flash[:success] = "Profile Saved"
				redirect_to user_profile_path(@profile)
			end
		else
			flash[:error] = "Unable to Save"
			render 'new'
		end
	end

	def edit
		@profile = Profile.find(params[:id])
	end

	def update
		@profile = Profile.find(params[:id])
		if @profile.update(safe_params)
			response = JSON.parse(open('http://ziptasticapi.com/' + @profile.zip).read)
			@profile.city = response['city']
			@profile.state = response['state']
			if @profile.save
				flash[:success] = "Profile Updated"
				redirect_to user_profile_path(@profile)
			end
		else
			flash[:error] = "Unable to Update"
			render 'edit'
		end
	end

	def destroy
		@profile = Profile.find(params[:id])
		if @profile.destroy
			flash[:success] = "Profile Deleted"
			redirect_to user_profiles_path
		else
			flash[:error] = "Unable to Delete"
			redirect_to user_profile_path(@profile)
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


	def safe_params
		safe_attributes = [
			:title,
			:description,
			:avatar,
			:wallpaper,
			:zip,
			:color,
		]
		params.require(:profile).permit(*safe_attributes)
	end
end