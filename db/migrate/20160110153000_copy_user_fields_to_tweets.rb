class CopyUserFieldsToTweets < ActiveRecord::Migration
  def up
    Tweet.connection.execute <<-SQL
      UPDATE tweets
        SET
          user_id = json_extract_path(body, 'user', 'id')::varchar::numeric,
          user_display_name = json_extract_path_text(body, 'user', 'name')::varchar,
          user_screen_name = json_extract_path_text(body, 'user', 'screen_name')::varchar
    SQL
  end
end
