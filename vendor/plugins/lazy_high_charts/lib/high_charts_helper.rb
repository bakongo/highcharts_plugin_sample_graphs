# coding: utf-8
module HighChartsHelper
 # ActiveSupport::JSON.unquote_hash_key_identifiers = false
  def high_chart(placeholder, object  , &block)
    object.html_options.merge!({:id=>placeholder})
    object.options[:chart][:renderTo] = placeholder
    high_graph(placeholder,object , &block).concat(content_tag("div","", object.html_options))
  end
  

  def high_graph(placeholder, object, &block)
    graph =<<-EOJS
    <script type="text/javascript">
    jQuery(function() {
          // 1. Define JSON options
          var options = {
                        chart: #{object.options[:chart].to_json},
                        title: #{object.options[:title].to_json},
                        legend: #{object.options[:legend].to_json},
                        xAxis: #{object.options[:x_axis].to_json},
                        yAxis: #{object.options[:y_axis].to_json},
                        tooltip:  #{object.options[:tooltip].to_json},
                        credits: #{object.options[:credits].to_json},
                        plotOptions: #{object.options[:plot_options].to_json},
                        series: #{do_series_data(object.data)},
                        subtitle: #{object.options[:subtitle].to_json}
                        };

          // 2. Add callbacks (non-JSON compliant)
          #{capture(&block) if block_given?}
          // 3. Build the chart
          var chart = new Highcharts.Chart(options);
      });
      </script>
    EOJS
    if defined?(raw)
      return raw(graph) 
    else
      return graph
    end
  end
  
  def do_series_data(data)
    out_str = "[ "
    series_strings = []
    data.each do |single_serie|
      values = []
      series_string = "{"
      single_serie.each do |key, val|
        if key == :pointStart || key == "pointStart"
          values << "#{key.to_json}: #{val}"
        else
          values << "#{key.to_json}: #{val.to_json}"
        end
      end
      series_string += values.join(', ')
      series_string += "}"
      series_strings << series_string
    end
    out_str += series_strings.join(', ')
    out_str + "]"
  end
  
  def time_series_chart(placeholder, object, &block)
    object.html_options.merge!({:id=>placeholder})
    object.options[:chart][:renderTo] = placeholder
    time_series_graph(placeholder,object, &block).concat(content_tag("div","", object.html_options))
  end

  def time_series_graph(placeholder, object, &block)
    logger.info("object data is #{object.data.inspect}")
    graph = javascript_tag <<-EOJS
    
    jQuery(function() {
      
      // 1. Define JSON options
      var time_options = {
            chart: #{object.options[:chart].to_json},
            title: #{object.options[:title].to_json},
             xAxis: {
                type: 'datetime',
             },
             yAxis: {
                title: {
                   text: '#{object.options[:yaxis][:title]}'
                },
             },
             tooltip: {
                      formatter: function() {
                         return '' +
                            Highcharts.dateFormat('%A %B %e %Y', this.x) + ': ' +
                            ' ' + Highcharts.numberFormat(this.y, 2) + ' #{object.options[:yaxis][:title]}';
                      }
            },
             plotOptions: {
               spline: {
                          lineWidth: 4,
                          states: {
                             hover: {
                                lineWidth: 5
                             }
                          },
                          marker: {
                             enabled: false,
                             states: {
                                hover: {
                                   enabled: true,
                                   symbol: 'circle',
                                   radius: 5,
                                   lineWidth: 1
                                }
                             }   
                          },
                          pointInterval: #{object.options[:plotOptions][:pointInterval]},
                          pointStart: #{object.options[:plotOptions][:pointStart]}
                       }
              },
             series: #{object.data.to_json},
          };

          // 2. Add callbacks (non-JSON compliant)
           #{capture(&block) if block_given?}
          // 3. Build the chart
          var time_chart = new Highcharts.Chart(time_options);
      });    

    EOJS
  end

end

