class MakeIdNumberLessPicky < ActiveRecord::Migration
  def change
    change_column :tweets, :id_number, 'numeric'
  end
end
