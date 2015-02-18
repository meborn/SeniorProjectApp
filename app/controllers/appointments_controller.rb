class AppointmentsController < ApplicationController
	before_filter :authenticate_user!
	before_action :get_user
	before_action :get_profile
	before_action :get_opening

	def new
		@appointment = Appointment.new
	end

	def create
		@appointment = Appointment.new
		@appointment.opening = @opening
		@appointment.profile = @profile
		@appointment.user = @user
		if @appointment.save
			flash[:success] = "Appointment Made!"
			redirect_to profile_path(@profile)
		else
			flash[:error] = "Unable to Make Appointment!"
			render 'new'
		end
	end

	private

	def get_user
		@user = current_user
	end

	def get_profile
		@profile = Profile.find(params[:profile_id])
	end

	def get_opening
		@opening = Opening.find(params[:opening_id])
	end

	def get_owner
		@owner = @profile.user
	end

	def owner?
		if @profile.user == @user
			return true
		end
		return false
	end

	def safe_params
		safe_attributes = [
			:profile_id,
			:opening_id,
		]
		params.require(:appointment).permit(*safe_params)
	end
end