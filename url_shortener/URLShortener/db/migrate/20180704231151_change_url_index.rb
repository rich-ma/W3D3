class ChangeUrlIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :visits, :shortened_url_id
    add_index :visits, :shortened_url_id
  end
end
