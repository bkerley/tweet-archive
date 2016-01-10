class CopyUserFieldsToTweets < ActiveRecord::Migration
  def up
    Tweet.connection.execute <<-SQL
      UPDATE tweets
        SET
          user_id = json_extract_path(body, 'user', 'id')::varchar::numeric,
          user_display_name = json_extract_path(body, 'user', 'name'),
          user_screen_name = json_extract_path(body, 'user', 'screen_name')
    SQL
  end
end
