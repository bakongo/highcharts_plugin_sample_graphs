# coding: utf-8
module HighChartsHelper
 # ActiveSupport::JSON.unquote_hash_key_identifiers = false
  def high_chart(placeholder, object  , &block)
    object.html_options.merge!({:id=>placeholder})
    object.options[:chart][:renderTo] = placeholder
    logger.info("Block given as #{block.inspect}")
    high_graph(placeholder, object, &block).concat(content_tag("div","", object.html_options))
  end
  
  def high_graph_options(&block)
    @js_options ||= []
    @js_options << capture(&block)
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
          #{@js_options}
          // 3. Build the chart
          var chart = new Highcharts.Chart(options);
      });
      </script>
    EOJS
    graph
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
  
end

