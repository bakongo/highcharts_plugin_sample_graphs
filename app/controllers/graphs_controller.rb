class GraphsController < ApplicationController

  def time_series
    number = 100
    @last_100_days = generate_dates(number)
    
    chart_title, chart_tag = "Chart One", "chart_ibe"
    metric = 'housing market'
    @highchart = HighChart.new('chart_tag') do |f|
      f.chart({:zoomType =>'x', :defaultSeriesType => 'spline'})
      f.title(:text => 'Flower Market')
      f.x_axis({:type =>'datetime'})
      f.y_axis({:title => 'flowers'})
      chart_begin_js = "Date.UTC(#{@last_100_days[0].year}, #{@last_100_days[0].month-1}, #{@last_100_days[0].day})"
      f.series(:name => 'violets', :data => generate_numbers(number), :pointStart => chart_begin_js, :pointInterval => 24*3600*1000)
      f.series(:name => 'sunflowers', :data => generate_numbers(number), :pointStart => chart_begin_js, :pointInterval => 24*3600*1000)
    end
  end
  
  # chart: #{object.options[:chart].to_json},
  # title: #{object.options[:title].to_json},
  # legend: #{object.options[:legend].to_json},
  # xAxis: #{object.options[:x_axis].to_json},
  # yAxis: #{object.options[:y_axis].to_json},
  # tooltip:  #{object.options[:tooltip].to_json},
  # credits: #{object.options[:credits].to_json},
  # plotOptions: #{object.options[:plot_options].to_json},
  # series: #{object.data.to_json},
  # subtitle: #{object.options[:subtitle].to_json}
  
  def time_series_original
    
    @highchart = HighChart.new('graph') do |f|
      f.title(:text => 'SCACs in Yard')
      f.chart(:defaultSeriesType => "timeseries")
      f.x_axis({:type => 'datetime', :maxZoom => 14*24*3600*1000})
      f.y_axis({:title => {:text => 'Exch Rate'}, :min => 0.6, :startOnTicket => false, :showFirstLabel => false})
      #f.plot_options({:area => {:lineWidth => 4, :fillColor => {:linearGradient => [0, 0, 0, 300]}}})
      f.series(:type => 'area', :name => 'asdf', :pointInterval => 24*3600*1000, :pointStart => 'Date.UTC(2006,1,1)', :data => generate_numbers(100))
    end
    
  end


  def pie_chart
    @categories = generate_categories(6)
    @numbers = generate_numbers(6)
    assoc = []
    @categories.each_with_index {|c,i| assoc << [c, @numbers[i]]}
    
    @highchart = HighChart.new('graph') do |f|
      f.title(:text => 'SCACs in Yard')
      f.options[:chart][:defaultSeriesType] = "pie"
      f.options[:x_axis][:categories] = @categories
      f.series(:type => 'pie', :name => 'SCAC Presence', :data => assoc)
    end
  end
  

  def bar_chart
    @categories = generate_categories(5)
    @numbers = generate_numbers(5)
    
    @highchart = HighChart.new('graph') do |f|
      f.title(:text => 'SCACs per Hour')
      f.y_axis({:title=> {:text=> 'Hours'}, :labels=>{:align=>'right'} })
      
      f.options[:chart][:defaultSeriesType] = "bar"
      f.options[:x_axis][:categories] = @categories
      @categories.each do |cat|        
        f.series(:name => cat, :data => generate_numbers(5))
      end
    end
  end
  
  def two_charts
    @categories = generate_categories(5)
    @numbers = generate_numbers(5)
    assoc = []
    @categories.each_with_index {|c,i| assoc << [c, @numbers[i]]}
    
    @highchart_one = HighChart.new('graph_one') do |f|
      f.title(:text => 'SCACs per Hour')
      f.y_axis({:title=> {:text=> 'Hours'}, :labels=>{:align=>'right'} })
      
      f.options[:chart][:defaultSeriesType] = "bar"
      f.options[:x_axis][:categories] = @categories
      @categories.each do |cat|        
        f.series(:name => cat, :data => generate_numbers(5))
      end
    end
    
    @highchart_two = HighChart.new('graph_two') do |f|
      f.title(:text => 'SCACs in Yard')
      f.options[:chart][:defaultSeriesType] = "pie"
      f.options[:x_axis][:categories] = @categories
      f.series(:type => 'pie', :name => 'SCAC Presence', :data => assoc)
    end
  end
  
  
  def area_spline
    @categories = generate_categories(5)
    @highchart = HighChart.new('graph') do |f|
      f.title(:text => 'SCACs in Yard')
      f.options[:chart][:defaultSeriesType] = "areaspline"
      f.options[:x_axis][:categories] = @categories
      f.options[:y_axis][:title] = "Miles in the Sky"
      f.options[:credits][:enabled] = false
      f.options[:plot_options][:areaspline][:fill_opacity] = 0.3
      f.series(:name => 'john', :data => generate_numbers(5))
      f.series(:name => 'jane', :data => generate_numbers(5))      
    end    
  end
  
  
  
  private
  def generate_dates(number)
    midnight = Time.now.at_beginning_of_day
    last_100_days = []
    (1..number).to_a.reverse.each {|d,index| last_100_days << (midnight - 86400*d)}
    logger.info last_100_days.inspect
    last_100_days
  end
  
  def generate_numbers(number)
    numbers = [rand(number)]
    (1...number).each_with_index {|v, i| numbers << (rand(number)+1)}
    numbers
  end
  
  def generate_categories(number)
    cats = ['DELE', 'KFTN', "ARES", 'LUCK', 'PINC', 'SCNN']
    cats[0...number]
  end
  
  
end
