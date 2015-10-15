
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

class VocalsController < ApplicationController
  before_action :set_vocal, only: [:show, :edit, :update, :destroy]

  # GET /vocals
  # GET /vocals.json
  def index
    @vocals = Vocal.where(individual_id: session['individual_id']).to_a
    @attachments_hash = Tools::to_hash(Attachment.where(individual_id: session['individual_id']).select('id,instrument_id,itype_id,name,content_type,created_at,is_parsed'))
  end  # index

  # GET /vocals/1
  # GET /vocals/1.json
  def show
  end

  # GET /vocals/new
  def new
    @vocal = Vocal.new
  end

  # GET /vocals/1/edit
  def edit
  end

  # POST /vocals
  # POST /vocals.json
  def create
    @vocal = Vocal.new(vocal_params)

    respond_to do |format|
      if @vocal.save
        format.html { redirect_to @vocal, notice: 'Vocal was successfully created.' }
        format.json { render action: 'show', status: :created, location: @vocal }
      else
        format.html { render action: 'new' }
        format.json { render json: @vocal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vocals/1
  # PATCH/PUT /vocals/1.json
  def update
    respond_to do |format|
      if @vocal.update(vocal_params)
        format.html { redirect_to @vocal, notice: 'Vocal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vocal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vocals/1
  # DELETE /vocals/1.json
  def destroy
    @vocal.destroy
    respond_to do |format|
      format.html { redirect_to vocals_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vocal
      @vocal = Vocal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vocal_params
      params.require(:vocal).permit(:individual_id, :attachment_id, :name, :speech_text, :start_time)
    end
end
