class User::OpeningsController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	before_action :get_user

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
		@opening = Opening.new
		@opening.start = start_datetime
		@opening.end = end_datetime
		@opening.user = @user
		if @opening.save
			flash[:success] = "Opening Saved!"
			redirect_to user_opening_path(@opening)
		else
			flass[:error] = "Unable to Save Opening!"
			render 'new'
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

	def get_user
		@user = current_user
	end

	def safe_params
		safe_attributes = [
			:start,
			:end,
		]
		params.require(:opening).permit(*safe_attributes)
	end

end