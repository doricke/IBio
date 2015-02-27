
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

class SleepsController < ApplicationController
  before_action :set_sleep, only: [:show, :edit, :update, :destroy]

  ##############################################################################
  # GET /sleeps
  # GET /sleeps.json
  def index
    @sleeps = Sleep.where(individual_id: session['individual_id']).to_a
    @instruments_hash = Tools::to_hash(Instrument.all)
    data = data_setup( @sleeps )

    @selected = {}
    data.keys.each do |instrument_id|
      data[ instrument_id ].each do |data_name, data_array|
        name = @instruments_hash[ instrument_id ].name + " " + data_name
        @selected[ name ] = true
      end  # do
    end  # do
      
    @chart = chart_setup( data, @instruments_hash, @selected )
  end  # index

##############################################################################
  def index2
    @sleeps = Sleep.where(individual_id: session['individual_id']).to_a
    @instruments_hash = Tools::to_hash(Instrument.all)
    data = data_setup( @sleeps )

    select = params[:selected]
    @selected = {}
    data.keys.each do |instrument_id|
      data[ instrument_id ].each do |data_name, data_array|
        name = @instruments_hash[ instrument_id ].name + " " + data_name
        @selected[ name ] = false
        @selected[ name ] = true if select[ name ]
      end  # do
    end  # do
    
    @chart = chart_setup( data, @instruments_hash, @selected )
  end  # index2
  
  ##############################################################################
  # GET /sleeps
  # GET /sleeps.json
  def boxplots
    @sleeps = Sleep.where(individual_id: session['individual_id']).to_a
    @instruments_hash = Tools::to_hash(Instrument.all)
    
    i = 0
    seen = {}
    names = []
    @sleeps.each do |sleep|
      if (seen[sleep.instrument_id].nil?)
        seen[sleep.instrument_id] = i
        names << @instruments_hash[ sleep.instrument_id ].name
        i += 1
      end  # if
    end  # do
    
    data = box_setup( @sleeps, @instruments_hash, seen )
    @chart = box_chart( data, @instruments_hash, names )
  end  # boxplots

##############################################################################
  def chart_setup( data, instruments_hash, selected )
    data_type = { 'sleep' => 'scatter', 'light sleep' => 'column', 'deep sleep' => 'column', 'REM sleep' => 'column', 'interruptions' => 'scatter' }
    # data_type = { 'sleep' => 'scatter', 'light sleep' => 'scatter', 'deep sleep' => 'scatter', 'REM sleep' => 'scatter', 'interruptions' => 'scatter' }
    chart = LazyHighCharts::HighChart.new('StockChart') do |f|
      f.title({ :text => "Sleep", style: {color: 'black', fontSize: '30px', fontWeight: 'bold'} })
      f.options[:xAxis] = {type: 'datetime', labels: {style: {color: 'black', fontSize: '18px'}}}
      f.options[:xAxis][:title] = {text: 'Date', style: {color: 'black', fontSize: '20px', fontWeight: 'bold'}}
      f.options[:yAxis][:labels][:style] = {color: 'black', fontSize: '16px'}
      f.options[:yAxis][:title][:text] = 'hours, interruptions'
      f.options[:yAxis][:title][:style] = {color: 'black', fontSize: '20px', fontWeight: 'bold'}
      f.options[:chart][:height] = 800
      # f.options[:legend][:floating] = 'true'
      
      f.options[:rangeSelector] = {}
      f.options[:rangeSelector][:enabled] = true
      f.options[:rangeSelector][:selected] = 1
      f.options[:rangeSelector][:inputEnabled] = {}
      f.options[:rangeSelector][:inputEnabled][:width] = 480
      f.options[:chart][:zoomType] = 'xy'

      # f.options[:xAxis][:categories] = days
      # f.plot_options({:series=>{:stacking=>"normal"}})
      f.options[:legend][:itemStyle] = {color: 'black', fontSize: '14px'}
      # f.series(:type => 'column', :name => 'Light', :data => @light_sleep )
      # f.series(:type => 'column', :name => 'Deep', :data => @deep_sleep )
      # f.series(:type => 'scatter', :name => 'Interruptions', :data => @interruptions )
      data.keys.each do |instrument_id|
        data[ instrument_id ].each do |data_name, data_array|
          name = instruments_hash[ instrument_id ].name + " " + data_name
          # puts "name: #{name}, selected: #{selected[name]}"
          f.series(:type => data_type[data_name], :name => name, :data => data_array) if selected[ name ]
        end  # do
      end  # do
    end  # do
  
    return chart
  end  # chart_setup
  
  ##############################################################################
  def box_data( data_series )
    sorted = data_series.sort
    mid = sorted.size / 2
    qtr = mid / 2
    ans = [sorted[0], sorted[qtr], sorted[mid], sorted[mid+qtr], sorted[-1] ]
    puts "box data: #{ans}"
    return ans
  end  # box_data
  
  ##############################################################################
  def box_chart( data, instruments_hash, names )
    puts "box_chart called, names: #{names}"
    
    chart = LazyHighCharts::HighChart.new('StockChart') do |f|
      f.title({ :text => "Fitbit" })
      f.options[:xAxis][:categories] = names
      f.options[:chart][:height] = 400
      f.options[:chart][:type] = 'boxplot'
      f.options[:legend][:enabled] = false
      f.options[:yAxis][:plotLines] = [{:value => 7, :color => 'red', :width => 1, :text => 'min'}, {:value => 8, :color => 'green', :width => 1}]
      
      boxes = []
      data.each do |name, data_array|
        boxes << box_data(data_array)
      end  # do
      f.series(:data => boxes)
    end  # do
    
    return chart
  end  # box_chart

##############################################################################
  def data_setup( sleeps )
    secs_hour = 60.0 * 60.0
    
    basis_watch = Instrument.where(name: "Basis watch").take

    data = {}

    sleeps.each do |sleep|
      sleep_time = sleep.start_time.to_i * 1000
      asleep = sleep.secs_asleep.to_f / secs_hour
      data[ sleep.instrument_id ] = {} if data[ sleep.instrument_id ].nil?
      
      if (sleep.secs_asleep > 0) && (sleep.instrument_id != basis_watch.id)
        data[ sleep.instrument_id ][ 'sleep' ] = [] if data[ sleep.instrument_id ][ 'sleep' ].nil?
        data[ sleep.instrument_id ][ 'sleep' ] << [sleep_time, asleep]
      else
        if (sleep.secs_asleep > 0)
          data[ sleep.instrument_id ][ 'sleep' ] = [] if data[ sleep.instrument_id ][ 'sleep' ].nil?
          data[ sleep.instrument_id ][ 'sleep' ] << [sleep_time, asleep] if (! sleep.light_sleep.nil?) && (sleep.light_sleep > 0)
        end  # if
      end  # if
      
      if (! sleep.light_sleep.nil?) && (sleep.light_sleep > 0)
        light = sleep.light_sleep.to_f / secs_hour
        data[ sleep.instrument_id ][ 'light sleep' ] = [] if data[ sleep.instrument_id ][ 'light sleep' ].nil?
        data[ sleep.instrument_id ][ 'light sleep' ] << [sleep_time, light]
      end  # if
      
      if (! sleep.deep_sleep.nil?) && (sleep.deep_sleep > 0)
        deep = sleep.deep_sleep.to_f / secs_hour
        data[ sleep.instrument_id ][ 'deep sleep' ] = [] if data[ sleep.instrument_id ][ 'deep sleep' ].nil?
        data[ sleep.instrument_id ][ 'deep sleep' ] << [sleep_time, deep]
      end  # if
      
      if (! sleep.rem_sleep.nil?) && (sleep.rem_sleep > 0)
        rem = sleep.rem_sleep.to_f / secs_hour
        data[ sleep.instrument_id ][ 'REM sleep' ] = [] if data[ sleep.instrument_id ][ 'REM sleep' ].nil?
        data[ sleep.instrument_id ][ 'REM sleep' ] << [sleep_time, rem]
      end  # if
      
      if (! sleep.interruptions.nil?) && (sleep.interruptions > 0)
        data[ sleep.instrument_id ][ 'interruptions' ] = [] if data[ sleep.instrument_id ][ 'interruptions' ].nil?
        data[ sleep.instrument_id ][ 'interruptions' ] << [sleep_time, sleep.interruptions]
      end  # if
    end  # do
    
    return data
  end  # data_setup
  
  ##############################################################################
  def box_setup( sleeps, instruments_hash, seen )
    secs_hour = 60.0 * 60.0
    
    basis_watch = Instrument.where(name: "Basis watch").take
    
    data = {}
    
    sleeps.each do |sleep|
      asleep = sleep.secs_asleep.to_f / secs_hour
      name = seen[ sleep.instrument_id ]
      data[ name ] = [] if data[ name ].nil?
      
      if (sleep.secs_asleep > 0) && (sleep.instrument_id != basis_watch.id)
        data[ name ] << asleep
        else
        if (sleep.secs_asleep > 0)
          data[ name ] << asleep if (! sleep.light_sleep.nil?) && (sleep.light_sleep > 0)
        end  # if
      end  # if
    end  # do
    
    return data
  end  # box_setup
  
  ##############################################################################
  # GET /sleeps/1
  # GET /sleeps/1.json
  def show
  end  # show

  ##############################################################################
  # GET /sleeps/new
  def new
    @sleep = Sleep.new
  end

  ##############################################################################
  # GET /sleeps/1/edit
  def edit
  end

  ##############################################################################
  # POST /sleeps
  # POST /sleeps.json
  def create
    @sleep = Sleep.new(sleep_params)

    respond_to do |format|
      if @sleep.save
        format.html { redirect_to @sleep, notice: 'Sleep was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sleep }
      else
        format.html { render action: 'new' }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }
      end
    end
  end

  ##############################################################################
  # PATCH/PUT /sleeps/1
  # PATCH/PUT /sleeps/1.json
  def update
    respond_to do |format|
      if @sleep.update(sleep_params)
        format.html { redirect_to @sleep, notice: 'Sleep was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }
      end
    end
  end

  ##############################################################################
  # DELETE /sleeps/1
  # DELETE /sleeps/1.json
  def destroy
    @sleep.destroy
    respond_to do |format|
      format.html { redirect_to sleeps_url }
      format.json { head :no_content }
    end
  end
  
  ##############################################################################
  def bland_altman
    all_individuals_measurements = Sleep.where(individual_id: session[:individual_id])
    #instruments used for that individual for sleeping data measurement
    instrument_ids = all_individuals_measurements.pluck(:instrument_id).uniq
    sleep_data = {}

    instruments = Hash[Instrument.pluck(:id, :name)]
    instrument_ids.each do |instrument_id|
      sleep_data[instruments[instrument_id]] = {}
    end

    #parses all measurement data for an individual into their respective buckets
    all_individuals_measurements.each do |measurement|
      #skip incomplete measurement data
      next if measurement.secs_asleep.nil? ||
          measurement.secs_asleep == 0 ||
          measurement.start_time.nil? ||
          measurement.end_time.nil?

      s_time = measurement.start_time
      e_time = measurement.end_time
      # period = "#{s_time.year}-#{s_time.month}-#{s_time.day} to #{e_time.year}-#{e_time.month}-#{e_time.day}"
      period = "#{s_time.year}-#{s_time.month}-#{s_time.day}"

      sleep_data[instruments[measurement.instrument_id]][period] = measurement.secs_asleep/3600.0
    end

    #sets up the data comparisons for the json
    data = {}
    instrument_ids.combination(2).each do |inst1, inst2|
      comparison = "#{instruments[inst1]} vs #{instruments[inst2]}"
      data[comparison] = {}
      data[comparison]['series'] = []
      x = []
      y = []
      pearsonx = []
      pearsony = []
      sleep_data[instruments[inst1]].each do |inst1_data_period, inst1_secs|
        if sleep_data[instruments[inst2]].include?(inst1_data_period)
          val1 = sleep_data[instruments[inst1]][inst1_data_period]
          val2 = sleep_data[instruments[inst2]][inst1_data_period]
          diff = val2 - val1
          mean = (val1 + val2)/2.0
          plotpoint = {}
          plotpoint['date_range'] = inst1_data_period
          plotpoint['x'] = mean
          plotpoint['y'] = diff
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
      
      #data.delete(comparison) if data[comparison].empty?
    end

    gon.data = data
  end  # bland_altman

  private
  ##############################################################################
    # Use callbacks to share common setup or constraints between actions.
    def set_sleep
      @sleep = Sleep.find(params[:id])
    end

##############################################################################
    # Never trust parameters from the scary internet, only allow the white list through.
    def sleep_params
      params.permit(:individual_id, :instrument_id, :image_id, :start_time, :end_time, :secs_asleep, :light_sleep, :deep_sleep, :rem_sleep, :interruptions, :qualifier, :selected)
    end  # sleep_params
end  # class
