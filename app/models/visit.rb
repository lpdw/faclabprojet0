# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  date_visit :datetime
#  place_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Visit < ApplicationRecord
  belongs_to :place
  validates  :date_visit, :presence => true
  validates  :place_id,   :presence  => true

  def self.to_csv
    stats = monthly_stats(2016,3)

    CSV.generate(headers: true) do |csv|
      stats.each do |stat|
        csv << stat
      end
    end
  end


  def self.monthly_stats(year,month)
    monthly_stats=  []
    monthly_stats << ["Jour", "Visites"]

    (1..31).each do |i|
      daily_count = Visit.where("YEAR(date_visit) = #{year} and MONTH(date_visit) = #{month} and DAY(date_visit) = #{i}").count
      unless(daily_count == 0)
        day = Date.new(year,month,i).to_s
        monthly_stats << [day, daily_count]
      end
    end
    return monthly_stats
  end


end
