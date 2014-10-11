class IndexRetweetedStatusId < ActiveRecord::Migration
  def up
    add_column :tweets, :retweeted_status_id, :string
    add_column :tweets, :in_reply_to_status_id, :string

    add_index :tweets, :retweeted_status_id
    add_index :tweets, :in_reply_to_status_id

    Tweet.connection.execute <<-SQL
      UPDATE tweets
        SET
          retweeted_status_id = json_extract_path(body, 'retweeted_status', 'id')
        WHERE NOT json_extract_path_text(body, 'retweeted_status', 'id') = 'null'
      SQL
    Tweet.connection.execute <<-SQL
      UPDATE tweets
        SET
          in_reply_to_status_id = json_extract_path(body, 'in_reply_to_status_id')
        WHERE NOT json_extract_path_text(body, 'in_reply_to_status_id') = 'null'
      SQL
  end

  def down
    remove_column :tweets, :retweeted_status_id, :string
    remove_column :tweets, :in_reply_to_status_id, :string
  end
end
