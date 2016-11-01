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
    monthly_stats = []
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

  def self.get_datas_for_hours(place_id,today_date,hour_start_param,hour_end_param)
    datas = Array.new
    i = 0
    while hour_start_param <= hour_end_param do
      datas[i] = {'datas' => Visit.where(
                   'place_id = ?
                    AND DATE(date_visit) = ? AND HOUR(date_visit) = ?',
                    place_id,
                    today_date,
                    hour_start_param,
                  ).count, 'labels' => "#{hour_start_param} h"}
                hour_start_param += 1
                i += 1
                puts datas.inspect
              end
              return datas
            end

    def self.get_datas_for_days(place_id,start_date_parse_param,end_date_parse_param,month_start_param)
      datas = Array.new
      i = 0
      while start_date_parse_param <= end_date_parse_param do
        datas[i] = {'datas'=>Visit.where('place_id = ?
                                AND MONTH(date_visit) = ? AND DATE(date_visit) = ?',
                                place_id,
                                month_start_param,
                                start_date_parse_param,
                                ).count,'labels'=>start_date_parse_param.strftime("%d/%m/%Y")}
                                start_date_parse_param += 1.days
                                i += 1
                                puts datas.inspect
        end
        return datas
    end

    def self.get_datas_for_weeks(place_id,end_date_parse_param,instance_of_start_date_param,start_date_parse_param)
      datas = Array.new
      i = 0
      while instance_of_start_date_param <= end_date_parse_param do
        datas[i] = {'datas'=> Visit.where('place_id = ?
                                AND DATE(date_visit) BETWEEN ? AND ?',
                                place_id,
                                start_date_parse_param,
                                instance_of_start_date_param
                                ).count, 'labels' => "Semaine : #{start_date_parse_param.strftime("%U")}"}
                                start_date_parse_param  = instance_of_start_date_param
                                instance_of_start_date_param   +=  1.weeks
                                i += 1
                                puts datas.inspect
        end
        return datas
    end

    def self.get_datas_for_months(place_id,month_start_param,month_end_param)
      datas = Array.new
      i = 0
      while month_start_param <= month_end_param do
        datas[i] = {'datas' => Visit.where('place_id = ?
                                AND MONTH(date_visit) = ?',
                                place_id,
                                month_start_param,
                                ).count, 'labels' => month_start_param}
                                month_start_param += 1
                                i += 1
                                puts datas.inspect
        end
        return datas
    end

    def self.get_datas_for_years(place_id,start_date_parse_param,end_date_parse_param,instance_of_start_date_param)
      datas = Array.new
      i = 0
      while end_date_parse_param > instance_of_start_date_param do
       datas[i] = {'datas' => Visit.where('place_id = ?
                              AND DATE(date_visit) BETWEEN ? AND ?',
                               place_id,
                               start_date_parse_param,
                               instance_of_start_date_param,
                               ).count, 'labels' => instance_of_start_date_param.strftime("%B %Y")}
                               start_date_parse_param = instance_of_start_date_param
                               instance_of_start_date_param   += 1.months
                               i += 1
                               puts datas.inspect
        end
        return datas
    end
end
