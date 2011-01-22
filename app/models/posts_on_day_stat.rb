class PostsOnDayStat < Statistic

  def self.generate(time=Time.now, post_range=(0..50))
    stat = self.new(:time => time)
    post_range.each do |n|
      data_point = DataPoint.users_with_posts_on_day(time,n)
      data_point.save
      stat.data_points << data_point
    end
    stat.compute_average
    stat.save
    stat
  end

end
