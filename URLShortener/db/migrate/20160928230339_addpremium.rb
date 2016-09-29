class Addpremium < ActiveRecord::Migration
  def change
    add_column :users, :premium, :boolean, default: false, null: false
  end
end
