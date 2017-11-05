class ConvertTweetsBodyToJsonb < ActiveRecord::Migration
  def change
    change_column :tweets, :body, :jsonb
  end
end
