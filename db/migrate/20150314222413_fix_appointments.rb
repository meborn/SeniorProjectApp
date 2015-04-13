class FixAppointments < ActiveRecord::Migration
  def change
  	remove_column :appointments, :start_app, :datetime
  	remove_column :appointments, :end_app, :datetime
  	remove_column :appointments, :owner, :belongs_to
  end
end
