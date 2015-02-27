
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

class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :show2, :edit, :update, :destroy]

  #################################################################################################
  # GET /places
  # GET /places.json
  def index
    @places = Place.all
    
    places_array = []
    @places.each do |place|
      places_array << DataMapBubble.new(place.id, 5, 5, place.city, '1', place.latitude, place.longitude).to_json
    end  # do
    @all_places = '[' + places_array.join(',') + ']'
  end  # index
  
  #################################################################################################
  def show_setup( place, airs, selected, itypes_hash )
    data = {}
    airs.each do |air|
      if selected[ air.itype_id ]
        data[ air.itype_id ] = [] if data[ air.itype_id ].nil?
        air_time = air.sampled_at.to_i * 1000
        data[ air.itype_id ] << [air_time, air.air_value]
      end  # if
    end  # do
    
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title({ :text => "Environmental Conditions;  latitude #{place.latitude}, longitude #{place.longitude}" })
      f.options[:chart][:defaultSeriesType] = "line"
      f.options[:xAxis][:type] = 'datetime'
      f.options[:chart][:height] = 600
      f.options[:chart][:zoomType] = 'x'
      
      data.keys.each do |itype|
        # f.series(:type => 'scatter', :name => itypes_hash[ itype ].name, :data => data[ itype ] )
        f.series(:type => 'spline', :name => itypes_hash[ itype ].name, :data => data[ itype ] )
      end  # do
    end  # do
    
    return chart
  end  # show_setup
  
  #################################################################################################
  # GET /places/1
  # GET /places/1.json
  def show
    # puts "####### Places.show params: #{params}"
    start_date = Time::local( 2014, 1, 1 )
    @itypes_hash = Tools::to_hash(Itype.where(category: 'Air').to_a)
    @airs = Air.where(place_id: @place.id).where('sampled_at >= ?', start_date).order(:sampled_at).to_a
    
    @selected = {}
    @airs.each do |air|
      if @selected.keys.size < 3
        @selected[ air.itype_id ] = true
        # puts ">>>>> selecting #{air.itype_id} : #{@itypes_hash[air.itype_id].name}"
      else
        @selected[ air.itype_id ] = false if @selected[ air.itype_id ].nil?
      end  # if
    end  # do
    
    @chart = show_setup( @place, @airs, @selected, @itypes_hash )
  end  # show
  
  #################################################################################################
  # PUT /places/1
  # PUT /places/1.json
  def show2
    # puts "####### Places.show2 params: #{params}"
    @itypes_hash = Tools::to_hash(Itype.where(category: 'Air').to_a)
    # puts "###### @itypes_hash.keys.size: #{@itypes_hash.keys.size}"
    start_date = Time::local( 2014, 1, 1 )
    # @airs = Air.where(place_id: @place.id).order(:sampled_at).to_a
    @airs = Air.where(place_id: @place.id).where('sampled_at >= ?', start_date).order(:sampled_at).to_a

    select = params[:selected]
    @selected = {}
    @airs.each do |air|
      if ! select[ air.itype_id.to_s ].nil?
        @selected[ air.itype_id ] = true
        else
        @selected[ air.itype_id ] = false
      end  # if
    end  # do
    
    @chart = show_setup( @place, @airs, @selected, @itypes_hash )
  end  # show2
  
#################################################################################################
  # GET /places/new
  def new
    @place = Place.new
  end

#################################################################################################
  # GET /places/1/edit
  def edit
  end

#################################################################################################
  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render action: 'show', status: :created, location: @place }
      else
        format.html { render action: 'new' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

#################################################################################################
  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

#################################################################################################
  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #################################################################################################
    def set_place
      @place = Place.find(params[:id])
    end

#################################################################################################
    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.permit(:city, :state, :longitude, :latitude, :selected)
    end
    #################################################################################################
end
