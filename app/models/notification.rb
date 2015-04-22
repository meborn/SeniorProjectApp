class Notification < ActiveRecord::Base

	enum event_type: [:appointment, :cancellation, :client, :review, :vender]
	belongs_to :user

	validates :user, presence: true
	validates :event, presence: true
	validates :event_type, presence: true

end