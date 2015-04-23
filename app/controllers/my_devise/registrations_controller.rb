class MyDevise::RegistrationsController < Devise::RegistrationsController
	def cancel
		super
	end

	def create
		super
	end

	def new
		super
	end

	def edit
		super
	end

	def update
		super
	end

	def destroy
		super
		if resource.destroy
			@owner_appointments = Appointment.where(:owner => resource).destroy_all
			@client_appointments = Appointment.where(:client => resource)
			@client_appointments.each do |c|
				@client_appointment_not = Notification.appointment.where(:event => c.id).destroy_all
				c.destroy
			end
			@clients = Client.where(:client => resource).destroy_all
			@openings = Opening.where(:user => resource).destroy_all
			@profiles = Profile.where(:user => resource)
			@profiles.each do |p|
				@vendor_not = Notification.vender.where(:event => p.id).destroy_all
				client = Client.where(:profile => p).where(:owner => resource)
				client.destroy_all
				p.destroy

			end
			@cancellations = Cancellation.where(:client => resource) + Cancellation.where(:owner => resource)
			@cancellations.each do |cancel|
				cancel_not = Notification.cancellation.where(:event => cancel.id).destroy_all
				cancel.destroy
			end
		end
	end
end