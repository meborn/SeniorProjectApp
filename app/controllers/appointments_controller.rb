class AppointmentsController < ApplicationController
	before_filter :authenticate_user!
	before_action :get_client
	before_action :get_profile
	before_action :get_opening

	def new
		@appointment = Appointment.new
	end

	def create
		@appointment = Appointment.new

		opening_conflict = date_conflicts?(Opening.where(:user => @client))
		owner_conflict = date_conflicts?(Appointment.where(:owner => @client))
		client_conflict = date_conflicts?(Appointment.where(:client => @client))
		if !opening_conflict && !owner_conflict && !client_conflict
			@appointment.profile = @opening.profile
			@appointment.owner = @opening.user
			@appointment.client = @client
			@appointment.start = @opening.start
			@appointment.end = @opening.end
			if @appointment.save
				n = Notification.new
				n.user = @profile.user
				n.event = @appointment.id
				n.appointment!
				n.save
				
				@opening.destroy
				flash[:success] = "Appointment Made!"
				redirect_to profile_path(@profile)
			else
				flash[:error] = "Unable to Make Appointment!"
				render 'new'
			end
		else
			if opening_conflict
				flash[:error] = "Unable to make appointment. You have an opening that conflicts with this appointment."
			else
				flash[:error] = "Unable to make appointment. You have another appointment that conflicts with this appointment."
			end
			redirect_to profile_openings_path(@profile)
		end
		
	end

	private

	def date_conflicts?(dates)
		start_date = @opening.start.to_i
		end_date = @opening.end.to_i
		dates.each do |date|
			start = date.start.to_i
			ending = date.end.to_i
			if start_date >= start && start_date < ending
				return true
			elsif end_date > start && end_date <= ending
				return true
			end
		end
		return false
	end

	def get_client
		@client = current_user
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
			:start,
			:end,
		]
		params.require(:appointment).permit(*safe_params)
	end
end