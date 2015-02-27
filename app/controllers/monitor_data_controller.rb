
################################################################################
# Copyright (C) 2015  Darrell O. Ricke, PhD
# Author::    	Darrell O. Ricke, Ph.D.  (mailto: Darrell.Ricke@ll.mit.edu)
# Copyright:: 	Copyright (c) 2014 MIT Lincoln Laboratory
# License::   	GNU GPL license  (http://www.gnu.org/licenses/gpl.html)
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
################################################################################

class MonitorDataController < ApplicationController
  before_action :set_monitor_datum, only: [:show, :edit, :update, :destroy]
  
  ################################################################################
  def get_date( params_date )
    puts "### params_date: #{params_date}"
    new_date = Date.new( params_date['(1i)'].to_i, params_date['(2i)'].to_i, params_date['(3i)'].to_i)
    puts "new date: #{new_date}"
    return new_date
  end  # get_date
  
  ################################################################################
  # GET /monitor_data
  # GET /monitor_data.json
  def index
    itype = Itype.where(name: "heart_rate").take
    @time_end = Time::now
    @time_start = @time_end - 60 * 60 * 24 * 60
    @date_end = Date::today
    @date_start = @date_end - 60
    @monitor_data = MonitorDatum.where(individual_id: session['individual_id'], itype_id: itype.id, start_time: @time_start..@time_end ).to_a
    @instruments_hash = Tools::to_hash(Instrument.all)
    @itypes_hash = Tools::to_hash(Itype.all)
    itypes = {}
    @selected = {}
    data_itypes = MonitorDatum.where(Individual_id: session['individual_id']).select(:itype_id).collect(&:itype_id).uniq
    data_itypes.each do |itype_id|
      @selected[ itype_id ] = false
      itypes[ itype_id ] = @itypes_hash[ itype_id ]
    end  # do
    @itypes = itypes.values
    air_temp = Itype.where(name: "air_temp").take
    skin_temp = Itype.where(name: "skin_temp").take
    core_temp = Itype.where(name: "core_temp").take
    @selected[ itype.id ] = true
    @selected[ air_temp.id ] = false
    @selected[ skin_temp.id ] = false
    @selected[ core_temp.id ] = false if ! core_temp.nil?
    @selected_id = itype.id
    @unit = Unit.find(itype.unit_id) if ! itype.unit_id.nil?
    units = ""
    units = @unit.name if ! @unit.nil?
    
    data, max_value = data_setup( @monitor_data, @itypes_hash, @selected )
    @chart = chart_setup( data, @instruments_hash, "Heart Rate", units, max_value )
  end  # end
  
  ################################################################################
  # GET /monitor_data
  # GET /monitor_data.json
  def index2
    @selected_id = params[:selected][0][:itype_id].to_i
    # @time_end = Time::now
    # @time_start = @time_end - 60 * 60 * 24 * 60
    @date_start = get_date( params['date_start'] )
    @date_end = get_date( params['date_end'] )
    @time_start = Time::local( @date_start.year, @date_start.month, @date_start.day )
    @time_end = Time::local( @date_end.year, @date_end.month, @date_end.day, 23, 59, 59, 999 )
    puts "date_start: #{@date_start}, time_start: #{@time_start}, date_end: #{@date_end}, time_end: #{@time_end}"
    
    @monitor_data = MonitorDatum.where(individual_id: session['individual_id'], itype_id: @selected_id, start_time: @time_start..@time_end ).to_a
    @instruments_hash = Tools::to_hash(Instrument.all)
    @itypes_hash = Tools::to_hash(Itype.all)
    
    # puts "********* @selected_id: #{@selected_id}"
    @selected = {}
    itypes = {}
    data_itypes = MonitorDatum.where(Individual_id: session['individual_id']).select(:itype_id).collect(&:itype_id).uniq
    data_itypes.each do |itype_id|
      itypes[ itype_id ] = @itypes_hash[ itype_id ]
    end  # do
    @selected[ @selected_id ] = true
    @itypes = itypes.values
    @itype = Itype.find(@selected_id)
    @unit = Unit.find(@itype.unit_id) if (! @itype.nil?) && (! @itype.unit_id.nil?)
    units = ""
    units = @unit.name if ! @unit.nil?
    
    data, max_value = data_setup( @monitor_data, @itypes_hash, @selected )
    
    # puts "###### @selected_id: #{@selected_id}, itypes_hash: #{@itypes_hash}"
    
    @chart = chart_setup( data, @instruments_hash, @itype.name, units, max_value )
  end  # index2

  ################################################################################
  # GET /monitor_data/1
  # GET /monitor_data/1.json
  def show
    @instrument = Instrument.where(id: @monitor_datum.instrument_id).take
    @itype = Itype.where(id: @monitor_datum.itype_id).take
  end  # show

  ################################################################################
  # GET /monitor_data/1/edit
  def edit
    @instruments = Instrument.order(:name).to_a
    @attachment = Attachment.where(id: @monitor_datum.attachment_id).take
    @itype = Itype.where(id: @monitor_datum.itype_id).take
  end  # edit

  ################################################################################
  # PATCH/PUT /monitor_data/1
  # PATCH/PUT /monitor_data/1.json
  def update
    respond_to do |format|
      if @monitor_datum.update(monitor_datum_params)
        format.html { redirect_to @monitor_datum, notice: 'Monitor datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @monitor_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  ################################################################################
  # DELETE /monitor_data/1
  # DELETE /monitor_data/1.json
  def destroy
    @monitor_datum.destroy
    respond_to do |format|
      format.html { redirect_to monitor_data_url }
      format.json { head :no_content }
    end
  end
  
  ##############################################################################
  def bland_altman
    @instruments_hash = Tools::to_hash(Instrument.all)
    @itypes_hash = Tools::to_hash(Itype.all)
    # @selected_id = params[:selected][0][:itype_id].to_i
    heart_rate = Itype.where(name: "heart_rate").take
    @monitor_data = MonitorDatum.where(individual_id: session['individual_id'], itype_id: heart_rate.id).to_a
    
    instr = {}
    @monitor_data.each do |monitor_datum|
      instr[ monitor_datum.instrument_id ] = true
    end  # do
    
    instrument_ids = instr.keys
    device_data = {}
    instrument_ids.each do |instrument_id|
      device_data[@instruments_hash[instrument_id].name] = {}
    end  # do
    
    @monitor_data.each do |monitor_datum|
      if (! monitor_datum.data_vector.nil?) && (monitor_datum.points_per_hour == 60)
        name = @instruments_hash[monitor_datum.instrument_id].name
        device_data[ name ] = {} if device_data[ name ].nil?
        data_vector = monitor_datum.data_vector.split( "," )
        s_time = monitor_datum.start_time
        data_vector.each do |data_point|
          period = "#{s_time.year}-#{s_time.month}-#{s_time.day}-#{s_time.hour}-#{s_time.min}"
          value = 0.0
          value = data_point.to_f if (! data_point.nil?) && (data_point.size > 0)
          device_data[ name ][ period ] = value if (value > 39.0)
          s_time += 60
        end  # do
       end  # if
    end  # do
    
    puts "--- device_data.keys: #{device_data.keys}"
    device_data.keys.each do |dev_name|
      puts "      >> #{dev_name} size #{device_data[dev_name].keys.size}"
    end  # do

    #sets up the data comparisons for the json
    data = {}
    instrument_ids.combination(2).each do |inst1, inst2|
      comparison = "#{@instruments_hash[inst1].name} vs #{@instruments_hash[inst2].name}"
      data[comparison] = {}
      data[comparison]['series'] = []
      x = []
      y = []
      pearsonx = []
      pearsony = []
      name = @instruments_hash[ inst1 ].name
      if ! device_data[ name ].nil? && (device_data[ name ].keys.size > 1)
        device_data[@instruments_hash[inst1].name].each do |inst1_time, inst1_rate|
          if device_data[@instruments_hash[inst2].name].include?(inst1_time)
            val1 = device_data[@instruments_hash[inst1].name][inst1_time]
            val2 = device_data[@instruments_hash[inst2].name][inst1_time]
            diff = val2 - val1
            mean = (val1 + val2)/2.0
            plotpoint = {}
            plotpoint['date_range'] = inst1_time
            plotpoint['x'] = mean
            plotpoint['y'] = diff
            if ( diff >= 100.0 )
              puts "#{@instruments_hash[inst1].name}: #{val1}, #{@instruments_hash[inst2].name}: #{val2}, mean: #{mean}, diff: #{diff}"
            end  # if
            data[comparison]['series'].append(plotpoint)
            x.append(mean)
            y.append(diff)
            pearsonx.append(val1)
            pearsony.append(val2)
          end  # if
        end  # do

        #checks if there is any valid data
        if data[comparison]['series'].empty?
          #if there is not, delete the key
          data.delete(comparison)
        else
          #adds the relevant data points to the data structure
          y_mean = y.sum/y.length.to_f
          data[comparison]['avg'] = y_mean.round(2)
          data[comparison]['stdDev'] = Statistics::standard_deviation(y, y_mean).round(2)
          data[comparison]['pearson'] = Statistics::pearson(pearsonx, pearsony).round(2)
        end  # if
      end  # if
    end  # do

    gon.data = data
  end  # bland_altman
  
  ##############################################################################
  def zephyr
      @instruments_hash = Tools::to_hash(Instrument.all)
      @itypes_hash = Tools::to_hash(Itype.all)
      zephyr = Instrument.where(name: "Zephyr BioHarness").take
      # @selected_id = params[:selected][0][:itype_id].to_i
      heart_rate = Itype.where(name: "heart_rate").take
      @monitor_data = MonitorDatum.where(individual_id: session['individual_id'], itype_id: heart_rate.id).to_a
      
      instr = {}
      @monitor_data.each do |monitor_datum|
        instr[ monitor_datum.instrument_id ] = true
      end  # do
      
      instrument_ids = instr.keys
      device_data = {}
      instrument_ids.each do |instrument_id|
        device_data[@instruments_hash[instrument_id].name] = {}
      end  # do
      
      @monitor_data.each do |monitor_datum|
        if (! monitor_datum.data_vector.nil?) && (monitor_datum.points_per_hour == 60)
          name = @instruments_hash[monitor_datum.instrument_id].name
          device_data[ name ] = {} if device_data[ name ].nil?
          data_vector = monitor_datum.data_vector.split( "," )
          s_time = monitor_datum.start_time
          data_vector.each do |data_point|
            period = "#{s_time.year}-#{s_time.month}-#{s_time.day}-#{s_time.hour}-#{s_time.min}"
            value = 0.0
            value = data_point.to_f if (! data_point.nil?) && (data_point.size > 0)
            device_data[ name ][ period ] = value if (value > 39.0)
            s_time += 60
          end  # do
        end  # if
      end  # do
      
      puts "--- device_data.keys: #{device_data.keys}"
      device_data.keys.each do |dev_name|
        puts "      >> #{dev_name} size #{device_data[dev_name].keys.size}"
      end  # do
      
      #sets up the data comparisons for the json
      data = {}
      instrument_ids.each do |inst1|
        if ( inst1 != zephyr.id )
          comparison = "#{zephyr.name} vs #{@instruments_hash[inst1].name}"
          data[comparison] = {}
          data[comparison]['series'] = []
          x = []
          y = []
          pearsonx = []
          pearsony = []
          name = @instruments_hash[ inst1 ].name
          if ! device_data[ name ].nil? && (device_data[ name ].keys.size > 1)
              device_data[@instruments_hash[inst1].name].each do |inst1_time, inst1_rate|
                  if device_data[zephyr.name].include?(inst1_time)
                      val1 = device_data[@instruments_hash[inst1].name][inst1_time]
                      val2 = device_data[zephyr.name][inst1_time]
                      diff = val2 - val1
                      mean = (val1 + val2)/2.0
                      plotpoint = {}
                      plotpoint['date_range'] = inst1_time
                      plotpoint['x'] = val2
                      plotpoint['y'] = diff
                      data[comparison]['series'].append(plotpoint)
                      x.append(val2)
                      y.append(diff)
                      pearsonx.append(val1)
                      pearsony.append(val2)
                  end  # if
              end  # do
              
              #checks if there is any valid data
              if data[comparison]['series'].empty?
                  #if there is not, delete the key
                  data.delete(comparison)
                  else
                  #adds the relevant data points to the data structure
                  y_mean = y.sum/y.length.to_f
                  data[comparison]['avg'] = y_mean.round(2)
                  data[comparison]['stdDev'] = Statistics::standard_deviation(y, y_mean).round(2)
                  data[comparison]['pearson'] = Statistics::pearson(pearsonx, pearsony).round(2)
              end  # if
          end  # if
        end  # if
      end  # do
      
      gon.data = data
  end  # zephyr

  ################################################################################
  def surface_map
    puts "****** params: #{params}"
    
    if params.has_key?('date') && (params[:date].size > 6)
      date_tokens = params['date'].split('-').map{ |e| e.to_i }
        @day = DateTime.new(date_tokens[0], date_tokens[1], date_tokens[2]).beginning_of_week(:sunday)
    else
      recent = MonitorDatum.where(individual_id: session[:individual_id]).last
      # @day = DateTime.now.beginning_of_week(:sunday)
      @day = recent.start_time.beginning_of_week(:sunday)
    end  # if
    
    basis = Instrument.where(name: "Basis watch").take
    @instrument_id = basis.id
    @instrument_id = params['instrument']['instrument_id'].to_i if params.has_key?('instrument') && (! params['instrument']['instrument_id'].nil?)

    heart_rate = Itype.where(name: "heart_rate").take
    @selected_id = heart_rate.id
    @selected_id = params[:selected][0][:itype_id].to_i if params.has_key?('selected')
    instrument_ids = MonitorDatum.where(Individual_id: session['individual_id'], itype_id: @selected_id).select(:instrument_id).collect(&:instrument_id).uniq
    instruments_hash = {}
    instrument_ids.each do |id|
      instruments_hash[ id ] = id
    end  # do
    instruments = Instrument.all
    @instruments = []
    instruments.each do |instrument|
      @instruments << instrument if ! instruments_hash[ instrument.id ].nil?
    end  # do

    gon.data = {}
    gon.data = MonitorDatum.get_surfacemap_data(session[:individual_id], @selected_id, @instrument_id, @day)
  end  # surface_map
 
  private
  ################################################################################
    # Use callbacks to share common setup or constraints between actions.
    def set_monitor_datum
      @monitor_datum = MonitorDatum.find(params[:id])
    end

  ################################################################################
    # Never trust parameters from the scary internet, only allow the white list through.
    def monitor_datum_params
        params.require(:monitor_datum).permit(:instrument_id, :individual_id, :attachment_id, :image_id, :itype_id, :start_time, :end_time, :points_per_second, :points_per_hour, :data_vector, :selected, :date_start, :date_end)
    end
  
################################################################################
  def chart_setup( data, instruments_hash, selected_name, units, max_value )
      
    chart = LazyHighCharts::HighChart.new('StockChart') do |f|
      f.title({ :text => selected_name, style: {color: 'black', fontSize: '30px', fontWeight: 'bold'} } )
      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:xAxis] = {type: 'datetime', labels: {style: {color: 'black', fontSize: '18px'}}}
      f.options[:xAxis][:title] = {text: 'Date', style: {color: 'black', fontSize: '20px', fontWeight: 'bold'}}
      
      f.options[:yAxis][:labels][:style] = {color: 'black', fontSize: '20px'}
      f.options[:yAxis][:max] = max_value
      f.options[:yAxis][:min] = 0
      f.options[:yAxis][:title] = {text: units, style: {color: 'black', fontSize: '20px', fontWeight: 'bold'}} # if (selected_name == "Heart Rate")
      # f.options[:yAxis] = [{:title => {:text => 'heart_rate'}},
      #                      {:title => {:text => 'core_temp'}, opposite: true},
      #                      {:title => {:text => 'skin_temp'}, opposite: true},
      #                      {:title => {:text => 'air_temp'}, opposite: true}]
      f.options[:chart][:height] = 600
      f.options[:chart][:zoomType] = 'xy'
      f.options[:rangeSelector] = {}
      f.options[:rangeSelector][:buttons] = [[:type => 'hour', :count => 1, :text => '1h'],
          [:type => 'day', :count => 1, :text => '1d'],
          [:type => 'month', :count => 1, :text => '1m'],
          [:type => 'year', :count => 1, :text => '1y'],
          [:type => 'all', :text => 'All']]
         
      # f.options[:legend][:floating] = 'true'
      f.options[:legend][:itemStyle] = {color: 'black', fontSize: '16px'}
      data.keys.each do |instrument_id|
        data[ instrument_id ].each do |data_name, data_array|
          puts "instrument_id: #{instrument_id}, data_name: #{data_name}"
          name = instruments_hash[ instrument_id ].name + " " + data_name
          f.series(:type => 'scatter', :name => name, :data => data_array, :pointInterval => 1)
        end  # do
      end  # do
    end  # do     
    
    return chart
  end  # chart_setup
  
################################################################################
  def data_setup( monitor_data, itypes_hash, selected )
    core_temp = Itype.where(name: "core_temp").take
    data = {}
    # start_date = Time::local( 2014, 07, 31 )
    max_data = 0.0
    monitor_data.each do |monitor_datum|
      if (! monitor_datum.data_vector.nil?) && (monitor_datum.points_per_hour == 60) && selected[ monitor_datum.itype_id] # && (monitor_datum.start_time > start_date )
        name = itypes_hash[ monitor_datum.itype_id ].name
        data[ monitor_datum.instrument_id ] = {} if data[ monitor_datum.instrument_id ].nil?
        # start_time = monitor_datum.start_time.to_i * 1000
        # utc = monitor_datum.start_time.localtime
        # start_time = Time::local( utc.year, utc.mon, utc.day, utc.hour, utc.min ).to_i * 1000
        offset = -5 * 60 * 60
        offset = -4 * 60 * 60 if monitor_datum.start_time.isdst
        start_time = (monitor_datum.start_time.localtime.to_i + offset) * 1000
        data[ monitor_datum.instrument_id ][ name ] = [] if data[ monitor_datum.instrument_id ][ name ].nil?
        data_vector = monitor_datum.data_vector.split( "," )
        data_vector.each do |data_point|
          value = 0.0
          value = data_point.to_f if (! data_point.nil?) && (data_point.size > 0)
          value = value * 9.0 / 5.0 + 32.0 if (! core_temp.nil?) && (monitor_datum.itype_id == core_temp.id) && (value != 0.0)
          data[ monitor_datum.instrument_id ][ name ] << [start_time, value] if (value > 0.0) || (value < 0.0)
          start_time += 60 * 1000
          max_data = value if value > max_data
        end  # do
        # activity_amount = monitor_datum.amount
        # data[ monitor_datum.instrument_id ][ monitor_datum.name ] << [start_time, activity_amount ]
      end  # if
    end  # do
    
    return data, max_data
  end  # data_setup
    
end
