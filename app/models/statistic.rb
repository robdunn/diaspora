class Statistic < ActiveRecord::Base
  has_many :data_points, :class_name => 'DataPoint', :order => 'data_key ASC'

  def compute_average
    users = 0
    sum = 0
    self.data_points.each do |d|
      sum += d.data_key.to_i*d.data_value
      users += d.data_value
    end
    self.average = sum.to_f/users
  end

  def distribution
    @dist ||= lambda {
      dist = ActiveSupport::OrderedHash.new
      self.data_points.each do |d|
        dist[d.data_key] = d.data_value.to_f/users_in_sample
      end
      dist
    }.call
  end

  def users_in_sample 
    @users ||= lambda {
      users = self.data_points.map{|d| d.data_value}
      users.inject do |total,curr|
        total += curr
      end
    }.call
  end

  def self.generate(*args)
    raise 'call generate from child statistic'
  end
end
