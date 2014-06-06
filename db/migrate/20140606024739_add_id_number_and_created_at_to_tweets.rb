class AddIdNumberAndCreatedAtToTweets < ActiveRecord::Migration
  def up
    add_column :tweets, 'id_number', 'numeric(24)'
    add_column :tweets, 'created_at', :datetime

    Tweet.connection.execute <<-SQL
      UPDATE tweets 
        SET id_number = id_str::numeric
      SQL
    Tweet.connection.execute <<-SQL
      UPDATE tweets
        SET created_at = json_extract_path_text(body, 'created_at')::timestamp
      SQL
  end

  def down
    remove_column :tweets, 'id_number'
    remove_column :tweets, 'created_at'
  end
end
