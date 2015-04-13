class ProfilesController < ApplicationController
	before_action :get_user
	before_action :get_profile, only: [:show]
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
		
	end

	private

	def get_user
		if user_signed_in?
			@user = current_user
		else
			@user = nil
		end
	end

	def get_profile
		@profile = Profile.find(params[:id])
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