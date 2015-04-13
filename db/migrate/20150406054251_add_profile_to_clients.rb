class AddProfileToClients < ActiveRecord::Migration
  def change
    add_reference :clients, :profile, index: true
  end
end
