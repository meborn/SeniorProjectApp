class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :user, index: true
      t.integer :event
      t.integer :type
      t.boolean :seen, :default => false
    end
  end
end
