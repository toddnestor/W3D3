class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :topic_id
      t.integer :url_id
      t.timestamps null: false
    end
    add_index :tags, :topic_id
    add_index :tags, :url_id
  end
end
