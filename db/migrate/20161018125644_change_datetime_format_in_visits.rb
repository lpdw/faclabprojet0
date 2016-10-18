class ChangeDatetimeFormatInVisits < ActiveRecord::Migration[5.0]
  def up
    change_column :visits, :date_visit, 'timestamp '
  end

  def down
    change_column :visits, :date_visit, :datetime
  end

end
