class CreateMastodons < ActiveRecord::Migration
  def change
    create_table :mastodons do |t|
      t.belongs_to :tweet, index: true, foreign_key: true, type: :uuid
      t.bigint :status_id

      t.timestamps null: false
    end
  end
end
