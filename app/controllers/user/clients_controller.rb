class User::ClientsController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	before_action :get_user
	before_action :get_profiles

	before_action :get_year, only: [:show]
	before_action :get_month, only: [:show]
	before_action :get_day, only: [:show]

	before_action :get_dates, only: [:show]

	def index
		@new_client_count = Client.where("owner_id =? AND approved =?", @user.id, false).count
		@clients = Client.includes(:client).where(:owner => @user).order("users.name ASC")

	end

	def show
		@client = Client.find(params[:id])
		@appointments = Appointment.where(:owner => @user).where(:client => @client.client).where("start >= ?", @date).order(:start).paginate :per_page => 5, :page => params[:page]
		@history = Appointment.where(:owner => @user).where(:client => @client.client).where("start <= ?", @date).order(:start).paginate :per_page => 5, :page => params[:page]
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
			old_n.seen = true
			old_n.save

			flash[:succes] = "#{client.client.name} is now a client of #{client.profile.title}"
		else
			flash[:error] = "Unable to approve client at this time. Try again later."
		end
		
		redirect_to user_clients_path
	end

	def destroy
		client = Client.find(params[:id])
		client.destroy
		old_n = Notification.client.where(:event => client.id).first
		if old_n
			old_n.destroy
		end
		
		redirect_to user_clients_path
	end 

	private

	def get_user
		@user = current_user
	end

	def get_profiles
		@profiles = Profile.where(:user => @user).order(:title)
	end

	def get_year
		@year = Date.today.year.to_i
	end

	def get_month
		@month = Date.today.month.to_i
	end

	def get_day
		@day = Date.today.day.to_i
	end

	def get_dates
		@date = DateTime.new(@year, @month, @day)
	end

	def safe_params
		safe_attributes = [
			:approved,
		]
		params.require(:client).permit(*safe_attributes)
	end

end