class RemovePhotoFromItem < ActiveRecord::Migration
  def change
    remove_column :items, :photo, :string
  end
end
