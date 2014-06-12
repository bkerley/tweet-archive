class IndexTweetsOnBody < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX 
        tweets_text_fulltext 
      ON 
        tweets
      USING 
        gin(to_tsvector('english', text))
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX
        tweets_text_fulltext
    SQL
  end
end
