class UsersController < ApplicationController
	before_filter :authenticate_user!
	require 'net/http'
	require 'open-uri'
	require 'json'
	def show
		@user = current_user
		@profiles = Profile.where(user: @user)
	end
end