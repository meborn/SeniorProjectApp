class RenameColumnTypeNotifications < ActiveRecord::Migration
  def change
  	rename_column :notifications, :type, :event_type
  end
end
