class CreateCancellations < ActiveRecord::Migration
  def change
    create_table :cancellations do |t|
      t.datetime :start
      t.datetime :end
      t.belongs_to :profile, index: true
      t.belongs_to :owner, index: true
      t.belongs_to :client, index: true
    end
  end
end
