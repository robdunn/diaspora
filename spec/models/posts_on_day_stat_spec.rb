require 'spec_helper'

describe PostsOnDayStat do
  describe '.generate' do
    before do
      @time = Time.now - 1.day

      1.times do |n|
        p = alice.post(:status_message, :message => 'hi', :to => alice.aspects.first)
        p.created_at = @time
        p.save
      end

      5.times do |n|
        p = bob.post(:status_message, :message => 'hi', :to => alice.aspects.first)
        p.created_at = @time
        p.save
      end
    end

    it 'creates a Statistic with a default date and range' do
      time = Time.now
      Time.stub!(:now).and_return(time)

      stat = PostsOnDayStat.generate
      stat.data_points.count.should == 51
      stat.time.should == time
    end

    context 'custom date' do
      before do
        @stat = PostsOnDayStat.generate(@time)
      end

      it 'creates a Statistic with a custom date' do
        @stat.time.should == @time
      end

      it 'returns only desired sampling' do
        @stat.users_in_sample.should == 2
      end
    end

    context 'custom range' do
      it 'creates a Statistic with a custom range' do
        stat = PostsOnDayStat.generate(Time.now, (2..32))
        stat.data_points.count.should == 31
      end
    end
  end
end
