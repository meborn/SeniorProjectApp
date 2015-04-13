class AddApprovedToClients < ActiveRecord::Migration
  def change
    add_column :clients, :approved, :boolean, :default => false
  end
end
