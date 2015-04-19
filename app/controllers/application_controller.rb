class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_action :get_user, if: :user_signed_in?
  before_action :get_notifications, if: :user_signed_in?
  before_action :get_user_profiles, if: :user_signed_in?
  before_action :get_vendors, if: :user_signed_in?

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

  def get_notifications
    @appointment_notifications = Notification.appointment.where("user_id = ? AND seen = ?", @user.id, false)
    @client_notifications = Notification.client.where("user_id = ? AND seen = ?", @user.id, false)
    @vender_notifications = Notification.vender.where("user_id = ? AND seen = ?", @user.id, false)
  end

  def get_user_profiles
    @user = current_user
    @profiles = Profile.where(user: @user)
  end

  def get_vendors
    # get profiles that a user is a client of
    @user_is_client = Client.where("client_id = ? AND approved = ?", @user.id, true)
  end
end
