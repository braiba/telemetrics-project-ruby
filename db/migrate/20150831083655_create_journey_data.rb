class CreateJourneyData < ActiveRecord::Migration
  def change
    create_table :journey_data do |t|
      t.integer :journey_id
      t.integer :row_index
      t.float   :distance
      t.decimal :timestamp
      t.decimal :speed
      t.decimal :altitude
      t.decimal :longitude
      t.decimal :latitude
    end
  end
end
