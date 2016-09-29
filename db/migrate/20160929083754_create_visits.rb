class CreateVisits < ActiveRecord::Migration[5.0]
  def change
    create_table :visits do |t|
      t.timestamp :date_visit
      t.integer :place_id

      t.timestamps
    end
  end
end
