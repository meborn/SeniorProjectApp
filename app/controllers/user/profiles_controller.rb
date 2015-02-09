class User::ProfilesController < ApplicationController
	before_filter :authenticate_user!
	require 'open-uri'
	require 'json'

	def index

	end

	def show
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

	end

	def update

	end

	def destroy

	end

	private

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