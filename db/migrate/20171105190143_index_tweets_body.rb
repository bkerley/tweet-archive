class IndexTweetsBody < ActiveRecord::Migration
  def change
    add_index :tweets, :body, using: 'gin'
  end
end
