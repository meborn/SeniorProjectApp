class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.belongs_to :client, index: true
      t.belongs_to :owner, index: true
    end
  end
end
