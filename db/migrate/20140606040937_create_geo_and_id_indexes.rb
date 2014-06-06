class CreateGeoAndIdIndexes < ActiveRecord::Migration
  def change
    add_index :tweets, :geo_point, using: :gist
    add_index :tweets, :id_number, unique: true
  end
end
