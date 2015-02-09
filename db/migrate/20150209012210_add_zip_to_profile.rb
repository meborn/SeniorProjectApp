class AddZipToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :zip, :string
  end
end
