class Cancellation < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  belongs_to :client, :class_name => 'User', :foreign_key => 'client_id'
  belongs_to :profile

  validates :start, presence: true
  validates :end, presence: true
  validates :client, presence: true
  validates :owner, presence: true
  validates :profile, presence: true
end