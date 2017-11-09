class AddFlavorToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :flavor, :string
  end
end
