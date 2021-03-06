class User::ClientsController < ApplicationController
	layout 'user'

	respond_to :html, :js

	before_filter :authenticate_user!
	#application controller
	before_action :get_user
	before_action :get_user_profiles
	before_action :get_notifications
	before_action :get_vendors
	before_action :get_profile_colors
	#application controller
	#before_action :get_events
	

	# before_action :get_year, only: [:show]
	# before_action :get_month, only: [:show]
	# before_action :get_day, only: [:show]

	# before_action :get_dates, only: [:show]

	def index
		@new_client_count = Client.where("owner_id =? AND approved =?", @user.id, false).count
		@new_clients = Client.includes(:client).where(:owner => @user).where(:approved => false).order("users.name ASC")
		@clients = Client.includes(:client).where(:owner => @user).where(:approved => true).order("users.name ASC")

	end

	def show
		date = DateTime.now.beginning_of_day
		@client = Client.find(params[:id])
		@appointments = Appointment.where(:owner => @user).where(:client => @client.client).where("start >= ?", date).order(:start).paginate :per_page => 5, :page => params[:page]
		@history = Appointment.where(:owner => @user).where(:client => @client.client).where("start <= ?", date).order(:start).paginate :per_page => 5, :page => params[:page]
	end

	def approve_client
		client = Client.find(params[:client_id])
		client.approved = true
		if client.save
			n = Notification.new
			n.user = User.find(client.client_id)
			n.event = client.id
			n.vender!
			n.seen = false
			n.save

			old_n = Notification.client.where(:event => client.id).first
			old_n.destroy

			flash[:succes] = "#{client.client.name} is now a client of #{client.profile.title}"
		else
			flash[:error] = "Unable to approve client at this time. Try again later."
		end
		
		redirect_to user_clients_path
	end

	def destroy
		client = Client.find(params[:id])
		appointments = Appointment.where(:client => client.client)
		appointments.destroy_all
		
		old_n = Notification.client.where(:event => client.id).first
		if old_n
			old_n.destroy
		end
		client.destroy
		flash[:success] = "Client has been deleted."
		if request.xhr?
			render js: "document.location = '#{user_clients_path}'"
		else
			redirect_to user_clients_path	
		end
		
		
	end 

	private

	# def get_year
	# 	@year = Date.today.year.to_i
	# end

	# def get_month
	# 	@month = Date.today.month.to_i
	# end

	# def get_day
	# 	@day = Date.today.day.to_i
	# end

	# def get_dates
	# 	@date = DateTime.new(@year, @month, @day)
	# end

	# def get_user
	#     @user = current_user
	#   end

	#   def get_notifications
	#     @appointment_notifications = Notification.appointment.where("user_id = ? AND seen = ?", @user.id, false)
	#     @client_notifications = Notification.client.where("user_id = ? AND seen = ?", @user.id, false)
	#     @vender_notifications = Notification.vender.where("user_id = ? AND seen = ?", @user.id, false)
	#   end

	#   def get_user_profiles
	#     @user = current_user
	#     @profiles = Profile.where(user: @user)
	#   end

	  # def get_vendors
	    
	  #   @user_is_client = Client.where("client_id = ? AND approved = ?", @user.id, true)
	  # end

	  # def get_events
	  #   today_start = DateTime.now.beginning_of_day

	  #   @openings = Opening.where(:user => @user).where("start >= ?",today_start).order(:start)
	  #   @client_appointments = Appointment.where(:client => @user).order(:start)
	  #   @owner_appointments = Appointment.where(:owner => @user).order(:start)

	  #   @events = @openings + @client_appointments + @owner_appointments
	  #   @events.sort_by! do |item|
	  #     item[:start]
	  #   end
	  # end

	  # def get_profile_colors
	  # 	@colors = []
	  # 	@user_is_client.each do |vendor|
	  # 		@colors.push(vendor.profile)
	  # 	end
	  # 	@colors = @colors + @profiles
	  # end

	def safe_params
		safe_attributes = [
			:approved,
		]
		params.require(:client).permit(*safe_attributes)
	end

end