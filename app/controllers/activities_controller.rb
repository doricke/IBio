
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

class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :display, :edit, :update, :destroy]

#############################################################################
  # GET /activities
  # GET /activities.json
  def index
    @activities = Activity.where(individual_id: session['individual_id']).to_a
  end  # index

#############################################################################
  # GET /activities/1
  # GET /activities/1.json
  def show
    #  @locations = Location.where(activity_id: @activity.id).sort_by{ |l| l.created_at }
    @locations = Location.where(activity_id: @activity.id).order(:created_at)
      
    start_loc = @locations.first
    @closest_places = Place.get_closest(start_loc)
      
    #air data between the activity start and end time at the closest places
    # air_data = Air.where(sampled_at: (@activity.start_time-12.hour)..(@activity.end_time+12.hour), place_id: @closest_places.map{|p| p[0].id})
    start_time = @activity.start_time
    date = Time::local(start_time.year, start_time.mon, start_time.day)
    air_data = Air.where(sampled_at: date..(date+1.day), place_id: @closest_places.map{|p| p[0].id})
      
    data = {}
    data['Time'] = @locations.map{ |l| l.created_at.to_i * 1000}
    data['Latitude (deg)'] = @locations.map{ |l| l.latitude }
    data['Longitude (deg)'] = @locations.map{ |l| l.longitude }
    data['Speed (m/s)'] = @locations.map{ |l| l.speed }
    data['Altitude'] = @locations.map{ |l| l.altitude }
    
    data['air'] = {}
    @closest_places.each do |place|
      data['air'][place[0].id] = {:"#{place[0].city}, #{place[0].state}" => {}}
    end
      
    itypes = Hash[Itype.pluck(:id,:name)]
    units = Hash[Unit.pluck(:id,:name)]
      
    air_data.each do |air_point|
      # data['air'][air_point.place_id].first.last["#{itypes[air_point.itype_id]} - #{units[air_point.unit_id]}"] ||= []
      data['air'][air_point.place_id].first.last["#{itypes[air_point.itype_id]}"] ||= []
      data_value = air_point.air_value
      # data_value /= 100 if data_value >= 100
      # data['air'][air_point.place_id].first.last["#{itypes[air_point.itype_id]} - #{units[air_point.unit_id]}"] << [air_point.sampled_at.to_i * 1000, data_value]
      data['air'][air_point.place_id].first.last["#{itypes[air_point.itype_id]}"] << [air_point.sampled_at.to_i * 1000, data_value]
    end  # do
      
    #sorting the data by time as highstocks requires it
    data['air'].each do |loc, place|
      place.first.last.each do |air, air_data|
        air_data.sort_by!{ |array| array.first }
      end  # do
    end  # do
      
    gon.data = data
  end  # show

#############################################################################
  # GET /activities/new
  def new
    @activity = Activity.new
    @itypes = Itype.where(category: 'activity').order(:name).to_a
  end  # new

#############################################################################
  # GET /activities/1/edit
  def edit
    @itypes = Itype.where(category: 'activity').order(:name).to_a
  end  # edit

#############################################################################
  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render action: 'show', status: :created, location: @activity }
      else
        @itypes = Itype.where(category: 'activity').order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end # if
    end  # do
  end  # create

#############################################################################
  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { head :no_content }
      else
        @itypes = Itype.where(category: 'activity').order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end  # if
    end  # do
  end  # update

#############################################################################
  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url }
      format.json { head :no_content }
    end  # do
  end  # destroy

#############################################################################
  # Calendar  
  def fullcal
    puts "### fullcal called"
    @activities = Activity.where(individual_id: session['individual_id']).to_a
    # render :layout => true
  end  # fullcal

#############################################################################
  def display
    place_id = params[:place_id]
    @itypes_hash = Tools::to_hash(Itype.where(category: 'Air').to_a)
    start_time = @activity.start_time
    start_date = Time::local( start_time.year, start_time.mon, start_time.day )
    end_time = @activity.end_time + 60*60
    @airs = Air.where(place_id: @place.id).where('(sampled_at >= ?) AND (sampled_at <= ?)', start_date, end_time).order(:sampled_at).to_a

    select = params[:selected]
    @selected = {}
    @airs.each do |air|
      if ! select[ air.itype_id.to_s ].nil?
        @selected[ air.itype_id ] = true
      else
        @selected[ air.itype_id ] = false
      end  # if
    end  # do


    gon.data = data
  end

#############################################################################
  def json_create
    puts "### json_create"
    # A json feed via an ajax post coming from Jcal. The json can be accessed thru the params variable.
    note = Note.create(comment: params[:note]) if ! params[:note].nil?     
    
    n = params[:repeats].to_i
    # n = 1 if n < 1
    for i in 0..n do
      @activity = Activity.new
      @activity = from_params(@activity, params, note)
      @activity.start_time = (i * 24).hours.since params[:start_time].to_datetime
      @activity.end_time = (i * 24).hours.since params[:end_time].to_datetime
        
      #respond_to do |format|
      if @activity.save
        @activity = Activity.new
      else
        session[:error] = false
      end # if
    end # for
    
    @activities = Activity.where(individual_id: session['individual_id']).to_a
    render :fullcal
  end  # json_create
    
#############################################################################
  def json_delete
    puts "### json_delete called"
    @activity = activity.find(params[:activity_id].to_i)
    @activity.destroy
    
    @activities = Activity.where(individual_id: session['individual_id']).to_a
    render :fullcal
  end # json_delete
    
#######################################################################################    
  def json_test
    puts "### json_test called"
    puts "### params: #{params}"
    @activities = Activity.where(individual_id: session['individual_id']).to_a
    # render a json object using the class Even which contains all the reservations for the resource.
    
    render :fullcal
  end # JSON feed for fullcal
  
#############################################################################
  def json_update
    puts "### json_update called"
    @activity = activity.find(params[:activity_id])
    note = nil
    note = Note.create(comment: params[:note]) if ! params[:note].nil?     
    @activity = from_params(@activity, params, note)
    @activity.update(:start_time => @activity.start_time, :end_time => @activity.end_time)
    @activities = Activity.where(individual_id: session['individual_id']).to_a
    render :fullcal
  end # json_update
    
#############################################################################
  def json_resize
    puts "#### json_resize called"
    @activity = Activity.find(params[:activity_id])
    note = nil
    note = Note.create(comment: params[:note]) if ! params[:note].nil?     
    @activity = from_params(@activity, params, note)
    day_delta = params[:day_delta].to_i
    minute_delta = params[:minute_delta].to_i
    puts "#### day_delta: #{day_delta}, minute_delta: #{minute_delta}"
    # if ( day_delta > 0 )
    #   @activity.start_time += day_delta * 60 * 60 * 24
    #   @activity.end_time += day_delta * 60 * 60 * 24
    # else
    #   @activity.start_time -= day_delta * 60 * 60 * 24
    #   @activity.end_time -= day_delta * 60 * 60 * 24
    # end  # if
    # if ( minute_delta > 0 )
    #   @activity.end_time += minute_delta * 60
    # else
    #   @activity.start_time -= minute_delta * 60
    # end  # if
    status = @activity.update(:start_time => @activity.start_time, :end_time => @activity.end_time, :activity_name => @activity.activity_name)
    puts ">>>>>json_resize status: #{status} @activity.id: #{@activity.id}, start_time: #{@activity.start_time}, end_time: #{@activity.end_time}"
    @activities = Activity.where(individual_id: session['individual_id']).to_a
    render :fullcal
  end # json_resize
        
#############################################################################
  def return_session
    # This method will notify jCal if the activity failed to be created. This is done via a JSON feed (server) and AJAX GET (client)
    puts "#### return_session called"
    @activities = Activity.where(individual_id: session['individual_id']).to_a
    render :fullcal
  end # return_session


#############################################################################
  private
#############################################################################
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end  # set_activity

#############################################################################
    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:individual_id, :itype_id, :image_id, :attachment_id, :note_id, :activity_name, :start_time, :end_time, :intensity, :qualifier, :title, :day_delta, :minute_delta, :selected, :place_id)
    end  # activity_params
    
#############################################################################
  def from_params(activity, params, note)
    activity.individual_id = session[:individual_id]
    activity.itype_id = params[:itype_id] if ! params[:itype_id].nil?
    activity.image_id = params[:image_id] if ! params[:image_id].nil?
    activity.attachment_id = params[:attachment_id] if ! params[:attachment_id].nil?
    activity.note.id = note.id if ! note.nil?
    activity.start_time = params[:start_time].to_datetime if ! params[:start_time].nil?
    activity.end_time = params[:end_time].to_datetime if ! params[:end_time].nil?
    activity.activity_name = params[:activity_name] if ! params[:activity_name].nil?
    activity.intensity = params[:intensity] if ! params[:intensity].nil?
    activity.intensity = 0 if activity.intensity.nil?
    activity.qualifier = params[:qualifier]
    activity.qualifier = "X" if activity.qualifier.nil?
    puts "### from_params called: activity_name: #{activity.activity_name}"
    return activity
  end  # from_params
    
#############################################################################
end  # class
