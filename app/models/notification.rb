class Notification < ActiveRecord::Base

	enum event_type: [:appointment, :client, :review, :vender]
	belongs_to :user
end