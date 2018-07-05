class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :topic, null: false
    end
    add_index :topics, :topic, unique: true
  end
end
