
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

class ReactionsController < ApplicationController
  before_action :set_reaction, only: [:show, :edit, :update, :destroy]

  # GET /reactions
  # GET /reactions.json
  def index
    @reactions = Reaction.all
  end

  # GET /reactions/1
  # GET /reactions/1.json
  def show
  end

  # GET /reactions/new
  def new
    @reaction = Reaction.new
  end

  # GET /reactions/1/edit
  def edit
  end

  # POST /reactions
  # POST /reactions.json
  def create
    @reaction = Reaction.new(reaction_params)

    respond_to do |format|
      if @reaction.save
        format.html { redirect_to @reaction, notice: 'Reaction was successfully created.' }
        format.json { render action: 'show', status: :created, location: @reaction }
      else
        format.html { render action: 'new' }
        format.json { render json: @reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reactions/1
  # PATCH/PUT /reactions/1.json
  def update
    respond_to do |format|
      if @reaction.update(reaction_params)
        format.html { redirect_to @reaction, notice: 'Reaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reactions/1
  # DELETE /reactions/1.json
  def destroy
    @reaction.destroy
    respond_to do |format|
      format.html { redirect_to reactions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reaction
      @reaction = Reaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reaction_params
      params.require(:reaction).permit(:pathway_id, :itype_id, :control_itype, :from, :to, :control, :rank)
    end
end
