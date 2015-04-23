class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  

  protected

  def configure_devise_permitted_parameters
    registration_params = [:name, :avatar, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end

  def get_user
      @user = current_user
  end

  def get_user_profiles
      @profiles = Profile.where(user: @user)
  end

  def get_notifications
      @appointment_notifications = Notification.appointment.where("user_id = ? AND seen = ?", @user.id, false)
      @client_notifications = Notification.client.where("user_id = ? AND seen = ?", @user.id, false)
      @vendor_notifications = Notification.vender.where("user_id = ? AND seen = ?", @user.id, false)
      @cancellation_notifications = Notification.cancellation.where("user_id = ? AND seen = ?", @user.id, false)
  end

  def get_vendors
      @user_is_client = Client.where("client_id = ? AND approved = ?", @user.id, true)
  end

  def get_profile_colors
    @colors = []
    @user_is_client.each do |vendor|
      @colors.push(vendor.profile)
    end
    @colors = @colors + @profiles
  end

  
end
