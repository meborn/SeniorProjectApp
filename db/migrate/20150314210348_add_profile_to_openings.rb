class AddProfileToOpenings < ActiveRecord::Migration
  def change
    add_reference :openings, :profile, index: true
  end
end
