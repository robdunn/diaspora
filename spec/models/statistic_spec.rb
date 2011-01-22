require 'spec_helper'

describe Statistic do
  before do
    @stat = Statistic.new
    @time = Time.now

    1.times do |n|
      p = alice.post(:status_message, :message => 'hi', :to => alice.aspects.first)
      p.created_at = @time
      p.save
    end

    5.times do |n|
      p = bob.post(:status_message, :message => 'hi', :to => bob.aspects.first)
      p.created_at = @time
      p.save
    end
    
    10.times do |n|
      p = eve.post(:status_message, :message => 'hi', :to => eve.aspects.first)
      p.created_at = @time
      p.save
    end

    (0..10).each do |n|
      @stat.data_points << DataPoint.users_with_posts_on_day(@time, n)
    end
  end

  describe '#compute_average' do
    it 'computes the average of all its DataPoints' do
      @stat.compute_average.should == 16.to_f/3
    end
  end

  describe '#distribution' do
    it 'generates an ordered hash' do
      @stat.distribution.class.should == ActiveSupport::OrderedHash
    end

    it 'correctly sets values' do
      dist = @stat.distribution
      [dist['1'], dist['5'], dist['10']].each do |d|
        d.should == 1.to_f/3
      end
    end

    it 'generates a distribution' do
      values = @stat.distribution.map{|d| d[1]}
      values.inject{ |sum, curr|
        sum += curr
      }.should == 1
    end
  end

  describe '#users_in_sample' do
    it 'returns a count' do
      @stat.users_in_sample.should == 3
    end
  end
end
