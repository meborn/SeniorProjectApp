class ChangeAppointments < ActiveRecord::Migration
	def change
		add_column :appointments, :start_app, :datetime
		add_column :appointments, :end_app, :datetime
	end
  
end
