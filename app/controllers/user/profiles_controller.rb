class User::ProfilesController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	
	before_action :get_user
	before_action :get_user_profiles
	before_action :get_notifications
	before_action :get_vendors
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
		@vendor_notifications = Notification.vender.where(:profile => @profile).destroy_all
		@cancellations = Cancellation.where(:profile => @profile)
		@cancellations.each do |c|
			n = Notification.cancellation.find(c.id).destroy
		end
		@appointments= Appointment.where(:profile => @profile).destroy_all
		@openings= Opening.where(:profile => @profile).destroy_all
		@clients = Client.where(:profile => @profile).destroy_all
		if @profile.destroy
			flash[:success] = "Profile Deleted"
			redirect_to user_profiles_path
		else
			flash[:error] = "Unable to Delete"
			redirect_to user_profile_path(@profile)
		end
	end

	private


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