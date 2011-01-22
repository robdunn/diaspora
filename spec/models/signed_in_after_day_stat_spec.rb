require 'spec_helper'

describe SignedInAfterDayStat do
  describe '.generate' do
    before do
      @time = Time.now

      @alice = alice
      @bob = bob
      @eve = eve

      @alice.current_sign_in_at = @time
      @bob.current_sign_in_at = @time - 1.day
      @eve.current_sign_in_at = @time - 5.day

      [@alice, @bob, @eve].each do |user|
        user.save
      end
    end

    it 'defaults to one week ago' do
      Time.stub!(:now).and_return(@time)

      stat = SignedInAfterDayStat.generate
      stat.data_points.count.should == 7
    end

    it 'results in a valid distribution' do
      stat = SignedInAfterDayStat.generate
      stat.distribution.values.sum.should == 1
    end
  end
end
