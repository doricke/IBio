
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

class PanelsController < ApplicationController
  before_action :set_panel, only: [:show, :edit, :update, :destroy]

  # GET /panels
  # GET /panels.json
  def index
    @panels = Panel.where(individual_id: session['individual_id']).to_a
    @itypes_hash = Tools::to_hash(Itype.where(category: 'panel').order(:name).to_a)
  end  # index

  # GET /panels/1
  # GET /panels/1.json
  def show
    @itype = Itype.find(@panel.itype_id) if ! @panel.itype_id.nil?
  end  # show

  # GET /panels/new
  def new
    @panel = Panel.new
    @itypes = Itype.where(category: 'panel').order(:name).to_a
 end  # new

  # GET /panels/1/edit
  def edit
    @itypes = Itype.where(category: 'panel').order(:name).to_a
  end  # edit

  # POST /panels
  # POST /panels.json
  def create
    @panel = Panel.new(panel_params)

    respond_to do |format|
      if @panel.save
        format.html { redirect_to @panel, notice: 'Panel was successfully created.' }
        format.json { render action: 'show', status: :created, location: @panel }
      else
        @itypes = Itype.where(category: 'panel').order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @panel.errors, status: :unprocessable_entity }
      end  # if
    end  # do
  end  # create

  # PATCH/PUT /panels/1
  # PATCH/PUT /panels/1.json
  def update
    respond_to do |format|
      if @panel.update(panel_params)
        format.html { redirect_to @panel, notice: 'Panel was successfully updated.' }
        format.json { head :no_content }
      else
        @itypes = Itype.where(category: 'panel').order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @panel.errors, status: :unprocessable_entity }
      end  # if
    end  # do
  end  # update

  # DELETE /panels/1
  # DELETE /panels/1.json
  def destroy
    @panel.destroy
    respond_to do |format|
      format.html { redirect_to panels_url }
      format.json { head :no_content }
    end  # do
  end  # destroy

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel
      @panel = Panel.find(params[:id])
    end  # set_panel

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_params
      params.require(:panel).permit(:individual_id, :attachment_id, :itype_id, :start_time, :end_time)
    end  # panel_params
end  # class
