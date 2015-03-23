class AddVideoColumnToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :link, :string
    add_column :microposts, :uid, :string
  end
end
