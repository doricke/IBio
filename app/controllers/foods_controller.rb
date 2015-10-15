
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

class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]
  autocomplete :food, :name, full: true, limit: 10

  # GET /foods
  # GET /foods.json
  def index
    @foods = Food.all.to_a
    @food = Food.new
    @itypes_hash = Tools::to_hash(Itype.where(category: 'food').to_a)
    @units_hash = Tools::to_hash(Unit.all.to_a)
  end  # index

  # GET /foods/1
  # GET /foods/1.json
  def show
  end

  # GET /foods/new
  def new
    @food = Food.new
    @itypes = Itype.where(category: 'food').to_a
    @units = Unit.where(true).to_a
  end

  # GET /foods/1/edit
  def edit
    @itypes = Itype.where(category: 'food').to_a
    @units = Unit.where(true).to_a
  end

  # POST /foods
  # POST /foods.json
  def create
    @food = Food.new(food_params)

    respond_to do |format|
      if @food.save
        format.html { redirect_to foods_url, notice: 'Food was successfully created.' }
        format.json { render action: 'show', status: :created, location: @food }
      else
        @itypes = Itype.where(category: 'food').to_a
        @units = Unit.where(true).to_a
        format.html { render action: 'new' }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /foods/1
  # PATCH/PUT /foods/1.json
  def update
    respond_to do |format|
      if @food.update(food_params)
        format.html { redirect_to foods_url, notice: 'Food was successfully updated.' }
        format.json { head :no_content }
      else
        @itypes = Itype.where(category: 'food').to_a
        @units = Unit.where(true).to_a
        format.html { render action: 'edit' }
        format.json { render json: @food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1
  # DELETE /foods/1.json
  def destroy
    @food.destroy
    respond_to do |format|
      format.html { redirect_to foods_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def food_params
      params.require(:food).permit(:name, :itype_id, :unit_id, :amount, :calories, :protein, :fats, :cholesterol, :weight, :saturated_fat)
    end
end
