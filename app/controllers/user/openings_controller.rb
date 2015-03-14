class User::OpeningsController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	before_action :get_user
	before_action :get_profiles

	def index
		@openings = Opening.where(:user => @user).order(:start)
	end

	def show
		@opening = Opening.find(params[:id])
	end

	def new
		@opening = Opening.new
	end

	def create
		start_datetime = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p')
		end_datetime = DateTime.strptime(safe_params[:end], '%Y/%m/%d %I:%M %p')
		if end_datetime.to_i <= start_datetime.to_i
			flash[:error] = "End DateTime must be after Start DateTime."
			redirect_to new_user_opening_path
		elsif future_date?
			if !date_conflicts?
				@opening = Opening.new
				@opening.start = start_datetime
				@opening.end = end_datetime
				@opening.user = @user
				@opening.profile_id = safe_params[:profile]
				if @opening.save
					flash[:success] = "Opening Saved!"
					redirect_to user_opening_path(@opening)
				else
					flash[:error] = "Unable to Save Opening!"
					render 'new'
				end
			else
				flash[:error] = "You have openings that conflict with these dates and times."
				redirect_to new_user_opening_path
			end
		else
			flash[:error] = "You can't make openings in the past."
			redirect_to new_user_opening_path
		end
	end

	def edit
		@opening = Opening.find(params[:id])
	end

	def update
		@opening = Opening.find(params[:id])
		@opening.start = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p')
		@opening.end = DateTime.strptime(safe_params[:end], '%Y/%m/%d %I:%M %p')
		if @opening.save
			flash[:success] = "Opening Edited!"
			redirect_to user_opening_path(@opening)
		else
			flass[:error] = "Unable to Edit Opening!"
			render 'edit'
		end
	end

	def destroy
		@opening = Opening.find(params[:id])
		if @opening.destroy
			flash[:success] = "Opening Deleted!"
			redirect_to user_openings_path
		else
			flash[:error] = "Unable to delete opening!"
			redirect_to user_openings_path
		end
	end

	private

	def future_date?
		current_date = DateTime.now.to_i
		start = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p').to_i
		if start > current_date
			return true
		else
			return false
		end
	end

	def date_conflicts?
		start_date = DateTime.strptime(safe_params[:start], '%Y/%m/%d %I:%M %p').to_i
		end_date = DateTime.strptime(safe_params[:end], '%Y/%m/%d %I:%M %p').to_i
		current_openings = Opening.where(:user => @user)
		current_openings.each do |opening|
			opening_start = opening.start.to_i
			opening_end = opening.end.to_i
			if start_date >= opening_start && start_date < opening_end
				return true
			elsif end_date > opening_start && end_date <= opening_end
				return true
			end
		end
		return false
	end

	def get_user
		@user = current_user
	end

	def get_profiles
		@profiles = Profile.where(:user => @user)
	end

	def safe_params
		safe_attributes = [
			:start,
			:end,
			:profile,
		]
		params.require(:opening).permit(*safe_attributes)
	end

end