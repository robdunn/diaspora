class DataPoint < ActiveRecord::Base
  belongs_to :statistic

  def self.users_with_posts_on_day(time, number)
    sql = ActiveRecord::Base.connection()
    value = sql.execute("SELECT COUNT(*) FROM (SELECT COUNT(*) AS post_sum, person_id FROM posts WHERE created_at >= '#{(time - 1.days).utc.to_datetime}' AND created_at <= '#{time.utc.to_datetime}' GROUP BY person_id) AS t1 WHERE t1.post_sum = #{number};").first[0]
    self.new(:data_key => number.to_s, :data_value => value)
  end

  def self.users_signed_in_on_day(time)
    value = User.where("current_sign_in_at > ? AND current_sign_in_at <= ?", (time -1.day).utc.to_datetime, time.utc.to_datetime).count
    self.new(:data_key => time, :data_value => value)
  end
end
