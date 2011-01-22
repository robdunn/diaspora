class SignedInAfterDayStat < Statistic

  def self.generate(last_date = Time.now - 6.days)
    stat = self.new(:time => Time.now)
    (last_date..Time.now).step(1.day) do |day|
      data_point = DataPoint.users_signed_in_on_day(day)
      data_point.save
      stat.data_points << data_point
    end
    stat.compute_average
    stat.save
    stat
  end
  
end
