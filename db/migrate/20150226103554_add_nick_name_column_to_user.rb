class AddNickNameColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :nick_name, :string
    add_index :users, :nick_name
  end
end
