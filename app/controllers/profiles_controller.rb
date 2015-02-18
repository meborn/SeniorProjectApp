class ProfilesController < ApplicationController
	before_action :get_user
	def index
		@profiles = Profile.all
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