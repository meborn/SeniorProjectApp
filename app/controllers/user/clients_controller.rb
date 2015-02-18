class User::ClientsController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	before_action :get_user
	before_action :get_profile

	def index
		@clients = @profile.clients 
	end

	private

	def get_user
		@user = current_user
	end

	def get_profile
		@profile = Profile.find(params[:profile_id])
	end
end