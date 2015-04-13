class ClientsController < ApplicationController
	before_filter :authenticate_user!
	before_action :get_profile
	before_action :get_user

	def create
		@client = Client.new
		@client.client = @user
		@client.profile = @profile
		@client.owner = @profile.user
		if @client.save
			n = Notification.new
			n.user = @profile.user
			n.event = @client.id
			n.client!
			n.save
			flash[:success] = "A client request has been sent. If the owner of this profile approves your request you will be able to make appointments with this user."
			redirect_to profile_path(@profile)
		else
			flash[:error] = "An error occured, your request was not sent. Please try again later. You can't make appointments with this user until you become a client."
			redirect_to profile_path(@profile)
		end
	end

	private

	def get_profile
		@profile = Profile.find(params[:profile_id])
	end

	def get_user
		@user = current_user
	end
end