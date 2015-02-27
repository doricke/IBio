
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

class EffectsController < ApplicationController
  before_action :set_effect, only: [:show, :edit, :update, :destroy]

  # GET /effects
  # GET /effects.json
  def index
    @effects = Effect.all
  end

  # GET /effects/1
  # GET /effects/1.json
  def show
  end

  # GET /effects/new
  def new
    @effect = Effect.new
  end

  # GET /effects/1/edit
  def edit
  end

  # POST /effects
  # POST /effects.json
  def create
    @effect = Effect.new(effect_params)

    respond_to do |format|
      if @effect.save
        format.html { redirect_to @effect, notice: 'Effect was successfully created.' }
        format.json { render action: 'show', status: :created, location: @effect }
      else
        format.html { render action: 'new' }
        format.json { render json: @effect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /effects/1
  # PATCH/PUT /effects/1.json
  def update
    respond_to do |format|
      if @effect.update(effect_params)
        format.html { redirect_to @effect, notice: 'Effect was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @effect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /effects/1
  # DELETE /effects/1.json
  def destroy
    @effect.destroy
    respond_to do |format|
      format.html { redirect_to effects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_effect
      @effect = Effect.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def effect_params
      params.require(:effect).permit(:biosequence_id, :variant_id, :guid2, :name, :impact, :function_class, :codon_change, :aa_change, :residue)
    end
end
