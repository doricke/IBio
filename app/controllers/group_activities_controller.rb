
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

class GroupActivitiesController < ApplicationController
  before_action :set_group_activity, only: [:show, :edit, :update, :destroy]

  # GET /group_activities
  # GET /group_activities.json
  def index
    @group_activities = GroupActivity.all
  end

  # GET /group_activities/1
  # GET /group_activities/1.json
  def show
  end

  # GET /group_activities/new
  def new
    @group_activity = GroupActivity.new
  end

  # GET /group_activities/1/edit
  def edit
  end

  # POST /group_activities
  # POST /group_activities.json
  def create
    @group_activity = GroupActivity.new(group_activity_params)

    respond_to do |format|
      if @group_activity.save
        format.html { redirect_to @group_activity, notice: 'Group activity was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group_activity }
      else
        format.html { render action: 'new' }
        format.json { render json: @group_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_activities/1
  # PATCH/PUT /group_activities/1.json
  def update
    respond_to do |format|
      if @group_activity.update(group_activity_params)
        format.html { redirect_to @group_activity, notice: 'Group activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_activities/1
  # DELETE /group_activities/1.json
  def destroy
    @group_activity.destroy
    respond_to do |format|
      format.html { redirect_to group_activities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_activity
      @group_activity = GroupActivity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_activity_params
      params.require(:group_activity).permit(:group_id, :activity_id)
    end
end
