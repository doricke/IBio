
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

class ActivitySummariesController < ApplicationController
  before_action :set_activity_summary, only: [:show, :edit, :update, :destroy]

################################################################################
  # GET /activity_summaries
  # GET /activity_summaries.json
  def index
    @activity_summaries = ActivitySummary.where(individual_id: session['individual_id']).order(:start_time).to_a
    @itypes_hash = Tools::to_hash(Itype.where(true).to_a)
    @instruments_hash = Tools::to_hash(Instrument.where(true).to_a)
    
    data = data_setup( @activity_summaries )
    @selected = {}
    data.keys.each do |instrument_id|
      data[ instrument_id ].each do |data_name, data_array|
        name = @instruments_hash[ instrument_id ].name + " " + data_name
        @selected[ name ] = true
      end  # do
    end  # do

    @chart = chart_setup( data, @instruments_hash, @selected )
  end  # index
  
  ################################################################################
  # GET /activity_summaries
  # GET /activity_summaries.json
  def index2
    @activity_summaries = ActivitySummary.where(individual_id: session['individual_id']).order(:start_time).to_a
    @itypes_hash = Tools::to_hash(Itype.where(true).to_a)
    @instruments_hash = Tools::to_hash(Instrument.where(true).to_a)
    
    data = data_setup( @activity_summaries )
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

################################################################################
  # GET /activity_summaries/1
  # GET /activity_summaries/1.json
  def show
    @itype = Itype.find(@activity.itype_id) if ! @activity.itype_id.nil?
  end

################################################################################
  # GET /activity_summaries/new
  def new
    @activity_summary = ActivitySummary.new
  end

################################################################################
  # GET /activity_summaries/1/edit
  def edit
    @itypes = Itype.where(category: 'activity').order(:name).to_a
  end

################################################################################
  # POST /activity_summaries
  # POST /activity_summaries.json
  def create
    @activity_summary = ActivitySummary.new(activity_summary_params)

    respond_to do |format|
      if @activity_summary.save
        format.html { redirect_to @activity_summary, notice: 'Activity summary was successfully created.' }
        format.json { render action: 'show', status: :created, location: @activity_summary }
      else
        @itypes = Itype.where(category: 'activity').order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @activity_summary.errors, status: :unprocessable_entity }
      end
    end
  end

################################################################################
  # PATCH/PUT /activity_summaries/1
  # PATCH/PUT /activity_summaries/1.json
  def update
    respond_to do |format|
      if @activity_summary.update(activity_summary_params)
        format.html { redirect_to @activity_summary, notice: 'Activity summary was successfully updated.' }
        format.json { head :no_content }
      else
        @itypes = Itype.where(category: 'activity').order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @activity_summary.errors, status: :unprocessable_entity }
      end
    end
  end

################################################################################
  # DELETE /activity_summaries/1
  # DELETE /activity_summaries/1.json
  def destroy
    @activity_summary.destroy
    respond_to do |format|
      format.html { redirect_to activity_summaries_url }
      format.json { head :no_content }
    end
  end

  private
################################################################################
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_summary
      @activity_summary = ActivitySummary.find(params[:id])
    end

################################################################################
    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_summary_params
      params.require(:activity_summary).permit(:individual_id, :instrument_id, :activity_id, :sleep_id, :image_id, :itype_id, :name, :qualifier, :amount, :start_time, :end_time, :is_public, :selected)
    end
    
################################################################################
    def chart_setup( data, instruments_hash, selected )
      chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({ :text => "Summaries Graph" })
        f.options[:chart][:defaultSeriesType] = "column"
        f.options[:xAxis][:type] = 'datetime'
        f.options[:chart][:height] = 600
        f.options[:chart][:zoomType] = 'x'
        # f.options[:rangeSelector][:selected] = 1
        
        # f.options[:legend][:floating] = 'true'
        # f.plot_options({:series=>{:stacking=>"normal"}})
        data.keys.each do |instrument_id|
          data[ instrument_id ].each do |data_name, data_array|
            name = instruments_hash[ instrument_id ].name + " " + data_name
            f.series(:type => 'spline', :name => name, :data => data_array) if selected[ name ]
          end  # do
        end  # do
      end  # do     

      return chart
    end  # chart_setup

################################################################################
    def data_setup( activity_summaries )
      data = {}
      activity_summaries.each do |activity_summary|
        data[ activity_summary.instrument_id ] = {} if data[ activity_summary.instrument_id ].nil?
        start_time = activity_summary.start_time.to_i * 1000
        data[ activity_summary.instrument_id ][ activity_summary.name ] = [] if data[ activity_summary.instrument_id ][ activity_summary.name ].nil?
        activity_amount = activity_summary.amount
        data[ activity_summary.instrument_id ][ activity_summary.name ] << [start_time, activity_amount ] if (activity_summary.name != "off_wrist") && (activity_summary.name != "inactive")
      end  # do
    
      return data
    end  # data_setup
    
################################################################################
end
