class StatisticsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :redirect_unauthorized
  
  def index
    @statistics = Statistic.find(:all, :order => 'created_at DESC').paginate(:page => params[:page], :per_page => 15)
  end

  def show
    @statistic = Statistic.where(:id => params[:id]).first
    @distribution = @statistic.distribution.values
    unless @statistic.users_in_sample == 0
      @google_chart_url = Gchart.line( :size => '700x400', 
                                      :title => "Posts on day",
                                      :bg => 'efefef',
                                      :legend => ['Posts'],
                                      :data => @distribution,
                                      :max_value => 1,
                                      :axis_with_labels => ['x','y'],
                                      :axis_labels => [(0..@distribution.length-1).to_a.map{|d| d%10==0 ? d : ''},
                                        (0..10).to_a.map!{|int| int.to_f/10}]
                                     )
    end
  end

  def new
    @statistic = Statistic.new
  end

  def create
    pp params[:statistic]['time(1i)']
    time = Time.parse("#{params[:statistic]['time(1i)']}" +
                  "-#{params[:statistic]['time(2i)']}" +
                  "-#{params[:statistic]['time(3i)']}" +
                  " #{params[:statistic]['time(4i)']}" +
                  ":#{params[:statistic]['time(5i)']}")
    stat = params[:statistic][:class].constantize.generate(time)
    redirect_to statistic_path(stat)
  end

  private
  def redirect_unauthorized
    unless AppConfig[:admins].include?(current_user.username)
      redirect_to root_url
    end
  end
end

