class AddColorToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :color, :string
  end
end
