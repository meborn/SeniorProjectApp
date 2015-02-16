class CreateOpenings < ActiveRecord::Migration
  def change
    create_table :openings do |t|
      t.datetime :start
      t.datetime :end
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
