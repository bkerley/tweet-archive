class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.belongs_to :tweet, index: true, foreign_key: true, type: :uuid
      t.integer :media_attachment_id
      t.integer :index
      t.attachment :file

      t.timestamps null: false
    end
  end
end
