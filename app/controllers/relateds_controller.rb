
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

class RelatedsController < ApplicationController
  before_action :set_related, only: [:show, :edit, :update, :destroy]

  # GET /relateds
  # GET /relateds.json
  def index
    @relateds = Related.all
    @itypes_hash = Tools::to_hash(Itype.where(category: 'related').order(:name).to_a)
  end  # index

  # GET /relateds/1
  # GET /relateds/1.json
  def show
    @itype = Itype.find(@related.itype_id) if ! @related.itype_id.nil?
  end  # show

  # GET /relateds/new
  def new
    @related = Related.new
    @itypes = Itype.where(category: 'related').order(:name).to_a
  end

  # GET /relateds/1/edit
  def edit
    @itypes = Itype.where(category: 'related').order(:name).to_a
  end

  # POST /relateds
  # POST /relateds.json
  def create
    @related = Related.new(related_params)

    respond_to do |format|
      if @related.save
        format.html { redirect_to @related, notice: 'Related was successfully created.' }
        format.json { render action: 'show', status: :created, location: @related }
      else
        @itypes = Itype.where(category: 'related').order(:name).to_a
        format.html { render action: 'new' }
        format.json { render json: @related.errors, status: :unprocessable_entity }/Users/da23452/Rails_Projects/IB/app/controllers/ievents_controller.rb
      end
    end
  end

  # PATCH/PUT /relateds/1
  # PATCH/PUT /relateds/1.json
  def update
    respond_to do |format|
      if @related.update(related_params)
        format.html { redirect_to @related, notice: 'Related was successfully updated.' }
        format.json { head :no_content }
      else
        @itypes = Itype.where(category: 'related').order(:name).to_a
        format.html { render action: 'edit' }
        format.json { render json: @related.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relateds/1
  # DELETE /relateds/1.json
  def destroy
    @related.destroy
    respond_to do |format|
      format.html { redirect_to relateds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_related
      @related = Related.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def related_params
      params.require(:related).permit(:family_id, :itype_id, :guid1a, :guild1b, :relation, :related)
    end
end
