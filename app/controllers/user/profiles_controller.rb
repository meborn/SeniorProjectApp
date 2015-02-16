class User::ProfilesController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	before_action :get_user
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

	def safe_params
		safe_attributes = [
			:title,
			:description,
			:avatar,
			:wallpaper,
			:zip,
		]
		params.require(:profile).permit(*safe_attributes)
	end
end