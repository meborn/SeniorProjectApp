class AddClientToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :client, :bleongs_to
  end
end
