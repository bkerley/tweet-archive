class AddUserFieldsToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :user_id, :numeric
    add_column :tweets, :user_display_name, :string
    add_column :tweets, :user_screen_name, :string
    add_index :tweets, :user_id
    add_index :tweets, :user_screen_name
  end
end
