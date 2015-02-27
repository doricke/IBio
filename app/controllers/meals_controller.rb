
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

class MealsController < ApplicationController
  before_action :set_meal, only: [:show, :edit, :update, :destroy]

  # GET /meals
  # GET /meals.json
  def index
    @meals = Meal.where(individual_id: session['individual_id']).to_a
  end

  # GET /meals/1
  # GET /meals/1.json
  def show
    @food_items = FoodItem.where(meal_id: @meal.id).to_a
    @foods_hash = Tools::to_hash(Food.order(:name).to_a)
    @units_hash = Tools::to_hash(Unit.order(:name).to_a)
  end  # show

  # GET /meals/new
  def new
    @meal = Meal.new
    @foods = Food.order(:name).to_a
    @units = Unit.order(:name).to_a
    @food_items = []
    for i in 1..10 do
      @food_items << FoodItem.new
    end  # for
  end  # new
    
  # GET /meals/new
  def new2
    # puts "##### new2 called"

    @meal = Meal.new
    @meal.consumed_at = params[:consumed_at]
    # puts "##### params: #{params}"
    @foods = Food.order(:name).to_a
    @units = Unit.order(:name).to_a
    @food_items = []
    for i in 1..10 do
      @food_items << FoodItem.new
    end  # for
    
    respond_to do |format|
      format.js {redirect_to  action: 'new3'}
      format.json { puts "#### new2.json called" }
      format.html { render 'new2' }
    end  # do
  end  # new2

  def new3
    # puts "##### new3 called"
    @meal = Meal.new
    @meal.consumed_at = params[:consumed_at]
    # puts "##### params: #{params}"
    @foods = Food.order(:name).to_a
    @units = Unit.order(:name).to_a
    @food_items = []
    for i in 1..10 do
      @food_items << FoodItem.new
    end  # for
    # puts "#### should render new3 now"
  end  # new3

  # GET /meals/1/edit
  def edit
    @food_items = FoodItem.where(meal_id: @meal.id).to_a
    @foods = Food.order(:name).to_a
    @units = Unit.order(:name).to_a
  end  # exit

  # POST /meals
  # POST /meals.json
  def create
    @meal = Meal.new(meal_params)
    @meal.individual_id = session[:individual_id]
    puts "####### Meals.create called: params: #{params}"
    food_items = params[:food_items]

    respond_to do |format|
      if @meal.save
        food_items.each do |food_item|
          @food_item = FoodItem.new( food_item )
          if (! @food_item.food_id.nil?)
            @food_item.meal_id = @meal.id
            @food_item.individual_id = session[:individual_id]
            @food_item.save
          end  # if
        end  # do
      
        format.html { redirect_to @meal, notice: 'Meal was successfully created.' }
        format.json { render action: 'show', status: :created, location: @meal }
      else
        @foods = Food.order(:name).to_a
        @units = Unit.order(:name).to_a

        format.html { render action: 'new' }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meals/1
  # PATCH/PUT /meals/1.json
  def update
    puts "####### Meals.update called: params: #{params}"
    respond_to do |format|
      if @meal.update(meal_params)
        format.html { redirect_to @meal, notice: 'Meal was successfully updated.' }
        format.json { head :no_content }
      else
        @foods = Food.order(:name).to_a
        @units = Unit.order(:name).to_a
      
        format.html { render action: 'edit' }
        format.json { render json: @meal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meals/1
  # DELETE /meals/1.json
  def destroy
    @meal.destroy
    respond_to do |format|
      format.html { redirect_to meals_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = Meal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meal_params
      params.require(:meal).permit(:individual_id, :consumed_at, :food_items)
    end
end
