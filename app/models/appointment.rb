class Appointment < ActiveRecord::Base
  belongs_to :opening
  belongs_to :user
  belongs_to :profile
end
