class Opening < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  validates :start, presence: true
  validates :end, presence: true
  validates :user_id, presence: true
  validates :profile_id, presence: true

end
