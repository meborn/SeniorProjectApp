class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.belongs_to :opening, index: true
      t.belongs_to :user, index: true
      t.belongs_to :profile, index: true

      t.timestamps
    end
  end
end
