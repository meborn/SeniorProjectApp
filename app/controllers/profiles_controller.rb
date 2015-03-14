class ProfilesController < ApplicationController
	before_action :get_user
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
		@profile = Profile.find(params[:id])
	end

	private

	def get_user
		if user_signed_in?
			@user = current_user
		end
	end
end