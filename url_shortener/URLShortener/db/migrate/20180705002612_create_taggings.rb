class CreateTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings do |t|
      t.integer :topic_id, null: false, index: true
      t.integer :url_id, null: false, index: true
      t.integer :user_id, null: false, index: true
    end
    add_index :taggings, [:topic_id, :url_id], unique: true
  end
  
end
