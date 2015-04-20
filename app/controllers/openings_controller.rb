class OpeningsController < ApplicationController
	before_filter :authenticate_user!
	before_action :get_profile
	before_action :get_owner
	before_action :get_user

	def index
		current_date = DateTime.now.beginning_of_day
		@openings = Opening.where(:profile => @profile).where("start >= ?", current_date).order(:start)
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
end